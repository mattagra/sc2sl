class Forum < ActiveRecord::Base
  has_many :topics, :dependent => :destroy
  has_many :comments, :through => :topics
  validates :title, :presence => true
  validates :description, :presence => true
  
  def last_comment_for(user)
    user and user.is_admin? ? comments.last : last_visible_comment
  end
  
  def last_visible_comment
    comments.where("topics.hidden = 0").last
  end
  
end
