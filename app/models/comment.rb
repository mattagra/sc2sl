class Comment < ActiveRecord::Base
  belongs_to :user

  validates :external_type, :presence => true, :inclusion => {:in => ["Article", "Team", "Game", "Match",  "Player", "User"]}
  validates :external_id, :presence => true, :numericality => true
  validates :user_id, :presence => true
  validates :description, :presence => true, :length => {:minimum => 5, :maximum => 750}

  scope :newest, order('id asc')

  scope :paginated, lambda { |page, offset|
    newest.limit(page).offset(offset.to_i * page.to_i)
  }

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
    self.description.bbcode_to_html(Sc2sl::Application::CUSTOM_BBCODE).bbcode_to_html({}, false, :disable, false)
  end

  has_one :moderation

end
