class User < ActiveRecord::Base
  acts_as_authentic do |c|
    #c.my_config_option = my_value # for available options see documentation in: Authlogic::ActsAsAuthentic
  end # block optional

  PERMISSION_LEVELS = { 0 => "banned", 1 => "normal", 2 => "moderator", 3 => "admin", 4 => "super-admin"}

  def self.find_by_login_or_email(login)
    find_by_login(login) || find_by_email(login)
  end

  has_attached_file :photo,
    {:styles => {
      :normal => "96x96",
      :thumb => "32x32"
    }, :url => "/images/:class/:attachment/:id/:style_:basename.:extension", :path => ":rails_root/public:url", :default_url => "/css/images/comment/avatar.jpg"}


  def avatar
    if self.photo_approved != false
      self.photo.url(:normal)
    end
  end

  attr_protected :permission_level, :login, :team_name, :caster, :website, :email
  
  validates :email, :presence => true, :uniqueness => true, :email_format => true
  validates :login, :presence => true, :uniqueness => true, :length => {:within => 3..20}, :format => { :with => /[A-Za-z0-9]+/ }
  validates_acceptance_of :terms, :on => :create
  after_validation :set_defaults, :on => :create

  has_many :my_comments, :class_name => "Comment"

  has_many :comments, :foreign_key => :external_id, :conditions => "external_type = '#{User.to_s}'"
  belongs_to :country

  has_many :moderations

  has_one :player, :conditions => ["players.date_quit is null"]
  has_many :players
  ajaxful_rater

  #has_many :games, :through => :players

  before_save :capitalize_names, :reset_tokens

  def capitalize_names
    self.first_name = self.first_name.capitalize
    self.last_name = self.last_name.capitalize
  end
  

  def set_defaults
    self.active = false
    self.permission_level = 1
  end

  def reset_tokens
    self.reset_perishable_token
    self.reset_single_access_token
  end

  def banned?
    (Moderation.where(:user_id => self.id, :mod_type => "permaban").count > 0) or (Moderation.where(:user_id => self.id).where(:mod_type => "ban").where("date(moderations.created_at, moderations.length || 'days') > datetime('now') ").count > 0)
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
    permission_level > 1
  end

  def is_admin?
    permission_level > 2
  end

  def is_super_admin?
    permission_level > 3
  end




  def permission_level_text
    PERMISSION_LEVELS[permission_level.to_i]
  end

end
