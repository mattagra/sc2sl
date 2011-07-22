class Article < ActiveRecord::Base

  #Acts as
  acts_as_url :title, :sync_url => true
  acts_as_taggable

  #Validations
  validates :url, :uniqueness => true
  validates :summary, :length => {:minimum => 5, :maximum => 128}
  validates :description, :length => {:minimum => 5, :maximum => 5096}
  

  #attached
  has_attached_file :photo, {:styles => { :normal => "641x253!" }, :url => "/images/:class/:attachment/:id/:style_:basename.:extension", :path => ":rails_root/public:url"}
  has_attached_file :featured_photo, {:styles => {:normal => "524x140"}, :url => "/images/:class/:attachment/:id/:style_:basename.:extension", :path => ":rails_root/public:url"}

  #Associations
  belongs_to :user
  has_many :comments, :foreign_key => :external_id, :conditions => "external_type = '#{Article.to_s}'"

  #Scopes
  scope :published, where(:published => true)
  scope :featured, where(:featured => true)
  scope :recent, order("articles.id desc").limit(20)
  scope :latest, order("articles.id desc").limit(1)
  scope :newest, order("articles.id desc")
  scope :paginated, lambda { |page, offset|
    newest.limit(page).offset(offset.to_i * page.to_i)
  }

  def to_s
    self.title
  end

  def featured_summary
    truncate_words(self.description, 1350)
  end

  def formatted_time
    if self.created_at
      self.created_at.strftime("%B %d %Y %H:%M")
    else
      Time.now.strftime("%B %d %Y %H:%M")
    end
  end

  def formatted_description
    self.description.bbcode_to_html.bbcode_to_html({}, false, :disable)
  end


end
