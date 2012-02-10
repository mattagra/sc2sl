class Post < ActiveRecord::Base
  belongs_to :topic
  belongs_to :user
  has_one :forum, :through => :topic
  
  
  
  validates :text, :presence => true
  validates :user, :presence => true
  
  scope :by_created_at, order("created_at asc")
  
  def owner_or_admin?(other_user)
    self.user == other_user || other_user.is_admin?
  end
  
  
  def formatted_time
    self.created_at.strftime("%b %d %Y %H:%M").upcase
  end

  def formatted_text
    self.text.bbcode_to_html(Sc2sl::Application::CUSTOM_BBCODE).bbcode_to_html({}, false, true, :disable)
  end
  
  
  
  
  
end
