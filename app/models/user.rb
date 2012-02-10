class User < ActiveRecord::Base
  #Authentication
  acts_as_authentic do |c|
    c.disable_perishable_token_maintenance true
    #c.my_config_option = my_value # for available options see documentation in: Authlogic::ActsAsAuthentic
  end # block optional

  #STATIC
  ROLES = %w[admin moderator superadmin]

  SERVERS = %w[Americas Europe Korea SEA China]

  #Scopes
  scope :with_role, lambda { |role| {:conditions => "roles_mask & #{2**ROLES.index(role.to_s)} > 0"} }
  scope :subscription, where(:subscription => true)
  scope :with_photos, where("photo_file_size > 0")
  scope :new_photos, with_photos.where(:photo_approved => nil)
  scope :approved_photos, with_photos.where(:photo_approved => true)
  
  
  scope :race, lambda{|x| where(:race => x) }


  #Attachments
  has_attached_file :photo,
    {:styles => {
      :normal => "96x96",
      :thumb => "32x32"
    }, :url => "/shared/users/:attachment/:id/:style_:basename.:extension", :path => ":rails_root/public:url", :default_url => "/css/images/comment/avatar.jpg"}


  #Attributes
  attr_protected :login, :caster, :website, :email, :roles

  #Validations
  validates :email, :presence => true, :uniqueness => true, :email_format => true
  validates :login, :presence => true, :uniqueness => true, :length => {:within => 3..20}, :format => { :with => /\A[A-Za-z0-9\-\_]+\Z/ }
  validates_acceptance_of :terms, :on => :create
  after_validation :set_defaults, :on => :create
  validates :signature, :length => {:within => 0..255}
  validates :profile_text, :length => {:maximum => 546}

  #Associations
  has_many :my_comments, :class_name => "Comment", :dependent => :destroy
  has_many :comments, :foreign_key => :external_id, :conditions => "external_type = '#{User.to_s}'", :dependent => :destroy
  belongs_to :country
  has_many :moderations, :dependent => :destroy
  has_one :player, :conditions => ["players.date_quit is null"]
  has_many :players, :dependent => :destroy
  has_many :retired_players, :class_name => "Player", :conditions => ["date_quit is not null"], :dependent => :destroy
  #has_many :games, :through => :players
  has_many :topics
  has_many :posts

  #Ratings
  ajaxful_rater
  scope :newest, order('id asc')
  scope :alphabetical, order('LOWER(login) asc')
  scope :recent, order('updated_at desc')
  scope :inactive, where(:active => false)
  

  before_save :capitalize_names #, :reset_tokens
  before_save :check_for_new_photo
  
  def to_s
    if self.first_name.to_s.length > 0
	  self.safe_name
	else
	  self.login.to_s
	end
  end
  
  def facebook_photo
    "http://graph.facebook.com/#{self.facebook_uid}/picture"
  end

  def self.paginated(page=1,offset=50)
    self.alphabetical.limit(offset).offset((page.to_i - 1) * offset.to_i)
  end


  def self.find_by_login_or_email(login)
    find_by_login(login) || find_by_email(login)
  end
  
  def connected_with_facebook?
    !self.facebook_uid.nil?
  end
  
  def before_connect(facebook_session)
	  self.first_name = facebook_session.first_name
	  self.last_name = facebook_session.last_name
	  self.email = facebook_session.email
	  self.login = "#{facebook_session.first_name.to_s.downcase}_#{Time.now.to_i.to_s}"[0..19]
	  self.password = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{self.login}--")[0,6]
	  self.password_confirmation = self.password
	  self.active = true
	  self.subscription = true
	  self.reset_tokens
	end


  def capitalize_names
    self.first_name = self.first_name.capitalize if self.first_name
    self.last_name = self.last_name.capitalize if self.last_name
  end
  
  def check_for_new_photo
    if self.photo_file_size_changed?
      self.photo_approved = nil
    end
	if self.photo_approved == false
	self.photo = nil
	end
  end

  def full_name
    self.first_name.to_s + " " + self.last_name.to_s
  end

  def safe_name
    self.first_name.to_s + " " + (if (self.last_name and self.last_name.length > 0) then self.last_name.to_s[0..0] + "." else "" end) 
  end
  
  def age
    now = Time.now.utc.to_date
    if self.birthdate
    now.year - birthdate.year - ((now.month > birthdate.month || (now.month == birthdate.month && now.day >= birthdate.day)) ? 0 : 1)
    else
      "Unknown"
    end
  end
  

  def set_defaults
    self.active = false if self.active.nil?
    self.subscription = true if self.subscription.nil?
  end

  def reset_tokens
    self.reset_perishable_token
    self.reset_single_access_token
  end

  def banned?
    (Moderation.where(:user_id => self.id, :mod_type => "permaban").count > 0) or (Moderation.where(:user_id => self.id).where(:mod_type => "banned").where("ends_at > CURRENT_TIMESTAMP").count > 0)
  end

  def current_ban
    self.moderations.order('id desc').last
  end

  def activate!
    self.active = true
    save!
  end


  def is_moderator?
    role?(:moderator) or role?(:admin) or role?(:superadmin)
  end

  def is_admin?
    role?(:admin) or role?(:superadmin)
  end

  def is_super_admin?
    role?(:superadmin)
  end


  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  def roles
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end

  def role?(role)
    roles.include? role.to_s
  end
  
  
  def save_with_validation(options=nil)
	  perform_validation = case options
		when Hash
		  options[:validate] != false
		when NilClass
		  true
		else
		  ActiveSupport::Deprecation.warn "save(#{options}) is deprecated, please give save(:validate => #{options}) instead", caller
		  options
	  end

	  # clear the remote validations so they don't interfere with the local
	  # ones. Otherwise we get an endless loop and can never change the
	  # fields so as to make the resource valid
	  @remote_errors = nil
	  if perform_validation && valid? || !perform_validation
		save_without_validation
		true
	  else
		false
	  end
	rescue ResourceInvalid => error
	  # cache the remote errors because every call to <tt>valid?</tt> clears
	  # all errors. We must keep a copy to add these back after local
	  # validations
	  @remote_errors = error
	  load_remote_errors(@remote_errors, true)
	  false
	end
    

end
