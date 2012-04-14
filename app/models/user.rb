class User < ActiveRecord::Base

  #Authentication
  #acts_as_authentic do |c|
  #  c.disable_perishable_token_maintenance true
    #c.my_config_option = my_value # for available options see documentation in: Authlogic::ActsAsAuthentic
  #end # block optional

  devise :database_authenticatable, :registerable, :recoverable, :encryptable,
         :rememberable, :trackable, :validatable, :confirmable, :lockable,
         :timeoutable, :omniauthable

  #STATIC
  ROLES = %w[admin moderator superadmin]

  SERVERS = %w[Americas Europe Korea SEA China]

  
  
  
  scope :race, lambda{|x| where(:race => x) }


  #Attachments
  has_attached_file :photo,
    {:styles => {
      :normal => "96x96",
      :thumb => "32x32"
    }, :url => "/shared/users/:attachment/:id/:style_:basename.:extension", :path => ":rails_root/public:url", :default_url => "comment/avatar.jpg"}


  #Attributes
  #attr_protected :caster, :website, :roles
  #attr_accessor  :password, :password_confirmation
  #attr_accessible :password, :password_confirmation, :photo, :country_id,  :signature, :bent_code, :bnet_name, :last_name, :profile_text, :subscription, :time_zone, :first_name, :race, :bnet_server, :birthdate
  #attr_accessible bnet_server, birthdate(1i), password_confirmation, birthdate(2i), caster, facebook_uid, country_id, birthdate(3i), signature, bent_code, photo_approved, last_name, profile_text, website, subscription, facebook_session_key, bnet_name, time_zone, login, password, roles, email, :first_name, :race, active
  #attr_accessible :caster, :facebook_uid, :photo_approved, :website, :facebook_session_key, :roles, :active
  
  #attr_accessible :email, :on => :create
  #attr_accessible :login, :on => :create
  #attr_accessible :encrypted_password, :on => :create

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
  
  #Scopes
  scope :with_role, lambda { |role| {:conditions => "roles_mask & #{2**ROLES.index(role.to_s)} > 0"} }
  scope :subscription, where(:subscription => true)
  scope :with_photos, where("photo_file_size > 0")
  scope :new_photos, with_photos.where(:photo_approved => nil)
  scope :approved_photos, with_photos.where(:photo_approved => true)
  scope :newest, order('id asc')
  scope :alphabetical, order('LOWER(login) asc')
  scope :recent, order('updated_at desc')
  scope :inactive, where("confirmed_at is null")
  scope :not_a_player, includes(:player).where("players.id is null")
  scope :is_a_player, includes(:player).where("players.id is not null")
  

  before_save :capitalize_names #, :reset_tokens
  before_save :check_for_new_photo

  
    def send_on_create_confirmation_instructions
      Devise::Mailer.delay.confirmation_instructions(self)
    end
    def send_reset_password_instructions
      Devise::Mailer.delay.reset_password_instructions(self)
    end
    def send_unlock_instructions
      Devise::Mailer.delay.unlock_instructions(self)
    end



  def self.find_for_database_authentication(conditions={})
    self.where("login = ?", conditions[:email]).limit(1).first ||
        self.where("email = ?", conditions[:email]).limit(1).first
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info
    if user = User.where(:email => data.email).first
      user
      if user.facebook_uid.blank?
        user.facebook_uid = data.id
        user.save!
      end
    else # Create a user with a stub password.
      logger.debug "Facebook attributes hash: #{data.inspect}"
      user = User.create!(:email => data.email, :password => Devise.friendly_token[0,20], :subscription => true, :login => (data.username.to_s.gsub(/[^0-9a-z]/i, '') + "_" + data.id.to_s)[0..19], :first_name => data.first_name, :last_name => data.last_name, :facebook_uid => data.id)
      user.confirm!
    end
    user
  end



  def to_s
    if connected_with_facebook? and first_name.to_s.length > 0 and last_name.to_s.length > 0
	  safe_name
	else
	  login.to_s
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
    self.subscription = true if self.subscription.nil?
  end

  #def reset_tokens
  #  self.reset_perishable_token
  #  self.reset_single_access_token
  #end

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
  
  def commentable(user)
    true
  end

  def active
    confirmed?
  end

  def active=(_new_active)
    if _new_active == true
      confirm!
    end
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
