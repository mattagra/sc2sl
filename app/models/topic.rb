class Topic < ActiveRecord::Base

  scope :hidden, where(:hidden => true)
  scope :visible, where(:hidden => false)
  scope :by_pinned, order('pinned DESC, id')
  scope :by_most_recent_comment, joins(:comments).select("DISTINCT comments.external_id, topics.*, comments.created_at").order("comments.created_at DESC, topics.id")
  scope :by_pinned_or_most_recent_comment, includes(:comments).order('topics.pinned DESC').order('comments.created_at DESC').order('topics.id')
  
  

  

  #attr_protected :pinned, :locked, :hidden

  belongs_to :forum
  belongs_to :user
  has_many :comments, :foreign_key => :external_id, :conditions => "external_type = '#{Topic.to_s}'", :dependent => :destroy
  accepts_nested_attributes_for :comments
  
  validates :title, :presence => true, :length => {:within => 5..45}
  validates :user, :presence => true
  validates :forum, :presence => true
  
  before_validation :set_first_comment_user
  before_validation :set_first_comment_object
  
  def lock_topic!
    self.locked = true

  end
  
  def unlock_topic!
    self.locked = false
  end
  
  def pin!
    self.pinned = true
  end
  
  def unpin!
    self.pinned = false
  end
  
  def owner_or_admin?(other_user)
    self.user == other_user || other_user.is_admin?
  end
  
  def commentable(user)
    if (self.hidden? or self.locked?) #and !user.is_admin?
	  false
	else
	  true
	end
  end
  
  
  protected
  def set_first_comment_user
    comment = self.comments.first
    comment.user = self.user
  end
  
  def set_first_comment_object
    comment = self.comments.first
	comment.external_type = "Topic"
	comment.external_id = self.id
  end

  
  
  
  
  
end
