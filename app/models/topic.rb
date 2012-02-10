class Topic < ActiveRecord::Base

  scope :hidden, where(:hidden => true)
  scope :visible, where(:hidden => false)
  scope :by_pinned, order('pinned DESC, id')
  scope :by_most_recent_post, joins(:posts).select("DISTINCT posts.topic_id, topics.*, posts.created_at").order("posts.created_at DESC, topics.id")
  scope :by_pinned_or_most_recent_post, includes(:posts).order('topics.pinned DESC').order('posts.created_at DESC').order('topics.id')
  
  

  

  attr_protected :pinned, :locked, :hidden

  belongs_to :forum
  belongs_to :user
  has_many :posts, :dependent => :destroy, :order => "created_at ASC"
  accepts_nested_attributes_for :posts
  
  validates :title, :presence => true
  validates :user, :presence => true
  validates :forum, :presence => true
  
  before_validation :set_first_post_user
  
  def lock_topic!
    update_attribute(:locked, true)
  end
  
  def unlock_topic!
    update_attribute(:locked, false)
  end
  
  def pin!
    update_attribute(:pinned, true)
  end
  
  def unpin!
    update_attribute(:pinned, false)
  end
  
  
  protected
  def set_first_post_user
    post = self.posts.first
    post.user = self.user
  end

  
  
  
  
  
end
