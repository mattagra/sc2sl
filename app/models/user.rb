class User < ActiveRecord::Base
  acts_as_authentic do |c|
    #c.my_config_option = my_value # for available options see documentation in: Authlogic::ActsAsAuthentic
  end # block optional
  
  validates :email, :presence => true, :uniqueness => true, :email_format => true
  validates :login, :presence => true, :uniqueness => true, :length => {:within => 3..20}
  after_validation :set_defaults, :on => :create
  has_attached_file :photo, :styles => { :small => "250x250>", :thumb => "100x100>" }


  

  def set_defaults
    self.active = false
  end


  def activate!
    self.active = true
    save!
  end

end
