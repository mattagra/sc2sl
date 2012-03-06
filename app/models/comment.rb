class Comment < ActiveRecord::Base

  #Associations
  belongs_to :user
  belongs_to :topic, :foreign_key => :external_id

  #Types
  EXTERNAL_TYPES = ["Article", "Team", "Game", "Match",  "Player", "User", "Topic"]

  #Validations
  validates :external_type, :inclusion => {:in => EXTERNAL_TYPES}
  #validates :external_id, :presence => true, :numericality => true
  validates :user_id, :presence => true
  validates :description, :presence => true, :length => {:minimum => 5, :maximum => 750}
  validate :validate_commentanble
  
  #Scopes
  scope :newest, order('id desc')
  scope :oldest, order('id asc')
  scope :recent, lambda {|user|
    where(:user_id => user.id).where("comments.created_at > ?",30.seconds.ago).limit(1)
  }
  
  Comment::EXTERNAL_TYPES.each do |e|
    scope e.to_sym, where(:external_type => e)
	belongs_to e.to_sym
  end
  
  

  def self.paginated(page=1,offset=10)
    oldest.limit(offset).offset((page.to_i - 1) * offset.to_i)
  end

  def external_object
    unless external_id.nil?
      external_type.try(:constantize).try(:find,external_id)
	else
	  nil
	end
  end
  
  def external_object=(e)
    self.external_type = e.class.to_s
	self.external_id = e.to_param
  end

  def external_page(order = :id, per_page = 10)
    position = self.external_object.comments.where("#{order} <= ?", self.send(order)).count
    (position.to_f/per_page).ceil
  end


  def self.new_of_type(model)
    new_object = Comment.new
    new_object.external_type = model.class.to_s
    new_object.external_id = model.to_param
    new_object
  end

  def formatted_time
    self.created_at.strftime("%b %d %Y %H:%M").upcase
  end

  def formatted_description
    self.description.bbcode_to_html(Sc2sl::Application::CUSTOM_BBCODE).bbcode_to_html({}, false, true, :disable)#.bbcode_to_html({}, false, true, :disable)
  end
  
  def owner_or_admin?(other_user)
    self.user == other_user || other_user.is_admin?
  end
  
  #Checks the external object and tests if the user is allowed to comment
  def commentable?
    self.external_object.nil? or (self.external_object and self.external_object.try(:commentable,user) != false)
  end
  
  def validate_commentanble
    if !commentable?
	  errors.add_to_base("This #{external_object.class.to_s} has been locked or no longer exists.")
	end
  end


  has_one :moderation

end
