class User < ActiveRecord::Base
  acts_as_authentic do |c|
    #c.my_config_option = my_value # for available options see documentation in: Authlogic::ActsAsAuthentic
  end # block optional

  attr_protected :permission_level, :login
  
  validates :email, :presence => true, :uniqueness => true, :email_format => true
  validates :login, :presence => true, :uniqueness => true, :length => {:within => 3..20}
  after_validation :set_defaults, :on => :create
  belongs_to :attachment

  has_many :my_comments, :class_name => "Comment"

  has_many :comments, :foreign_key => :external_id, :conditions => "external_type = '#{User.to_s}'"
  belongs_to :country

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

  def ban
    self.permission_level = 0
    self.save
  end

  def ban!
    self.permission_level = 0
    self.save!
  end

  def activate!
    self.active = true
    save!
  end

  def to_s
    self.first_name + " " + self.last_name
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


end
