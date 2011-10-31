class User < ActiveRecord::Base
  #Authentication
  acts_as_authentic do |c|
    #c.my_config_option = my_value # for available options see documentation in: Authlogic::ActsAsAuthentic
  end # block optional

  #STATIC
  ROLES = %w[admin moderator superadmin]

  SERVERS = %w[Americas Europe Korea SEA China]

  #Scopes
  scope :with_role, lambda { |role| {:conditions => "roles_mask & #{2**ROLES.index(role.to_s)} > 0"} }
  scope :subscription, where(:subscription => true)


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
  validates :login, :presence => true, :uniqueness => true, :length => {:within => 3..20}, :format => { :with => /[A-Za-z0-9]+/ }
  validates_acceptance_of :terms, :on => :create
  after_validation :set_defaults, :on => :create
  validates :signature, :length => {:within => 0..255}
  validates :profile_text, :length => {:maximum => 546}

  #Associations
  has_many :my_comments, :class_name => "Comment"
  has_many :comments, :foreign_key => :external_id, :conditions => "external_type = '#{User.to_s}'"
  belongs_to :country
  has_many :moderations
  has_one :player, :conditions => ["players.date_quit is null"]
  has_many :players
  has_many :retired_players, :class_name => "Player", :conditions => ["date_quit is not null"]
  #has_many :games, :through => :players

  #Ratings
  ajaxful_rater
  scope :newest, order('id asc')
  scope :alphabetical, order('LOWER(login) asc')
  scope :recent, order('updated_at desc')
  

  before_save :capitalize_names, :reset_tokens

  def self.paginated(page=1,offset=50)
    self.alphabetical.limit(offset).offset((page.to_i - 1) * offset.to_i)
  end


  def self.find_by_login_or_email(login)
    find_by_login(login) || find_by_email(login)
  end


  def capitalize_names
    self.first_name = self.first_name.capitalize
    self.last_name = self.last_name.capitalize
  end

  def full_name
    self.first_name.to_s + " " + self.last_name.to_s
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
    self.active = false
    self.subscription = true
  end

  def reset_tokens
    self.reset_perishable_token
    self.reset_single_access_token
  end

  def banned?
    (Moderation.where(:user_id => self.id, :mod_type => "permaban").count > 0) or (Moderation.where(:user_id => self.id).where(:mod_type => "ban").where("ends_at > CURRENT_TIMESTAMP").count > 0)
  end

  def current_ban
    self.moderations.order('id desc').last
  end

  def activate!
    self.active = true
    save!
  end

  def to_s
    self.login
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



  

end
