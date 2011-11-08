class Comment < ActiveRecord::Base

  #Associations
  belongs_to :user

  #Validations
  validates :external_type, :presence => true, :inclusion => {:in => ["Article", "Team", "Game", "Match",  "Player", "User"]}
  validates :external_id, :presence => true, :numericality => true
  validates :user_id, :presence => true
  validates :description, :presence => true, :length => {:minimum => 5, :maximum => 750}

  #Scopes
  scope :newest, order('id desc')
  scope :oldest, order('id asc')
  scope :recent, lambda {|user|
    where(:user_id => user.id).where("comments.created_at > ?",30.seconds.ago).limit(1)
  }

  def self.paginated(page=1,offset=10)
    oldest.limit(offset).offset((page.to_i - 1) * offset.to_i)
  end

  def external_object
    case self.external_type
    when "Article"
      Article.find(self.external_id)
    when "Team"
      Team.find(self.external_id)
    when "Game"
      Game.find(self.external_id)
    when "Match"
      Match.find(self.external_id)
    when "Player"
      Player.find(self.external_id)
    when "User"
      User.find(self.external_id)
    end
  end

  def external_page(order = :id, per_page = 10)
    position = self.external_object.comments.where("#{order} <= ?", self.send(order)).count
    (position.to_f/per_page).ceil
  end


  def self.new_of_type(model)
    new_object = self.new
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


  has_one :moderation

end
