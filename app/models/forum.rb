class Forum < ActiveRecord::Base
  has_many :topics, :dependent => :destroy
  has_many :posts, :through => :topics
  validates :title, :presence => true
  validates :description, :presence => true
  
  def last_post_for(user)
    user and user.is_admin? ? posts.last : last_visible_post
  end
  
  def last_visible_post
    posts.where("topics.hidden = 0").last
  end
  
end
