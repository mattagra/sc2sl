class Article < ActiveRecord::Base

  #Acts as
  acts_as_url :title, :sync_url => true
  acts_as_taggable

  #Validations
  validates :url, :uniqueness => true
  validates :summary, :length => {:minimum => 5, :maximum => 128}
  validates :description, :length => {:minimum => 5}
  validates_attachment_presence :photo                    
  validates_attachment_size :photo, :less_than=>1.megabyte
  validates_attachment_content_type :photo, :content_type=>['image/jpeg', 'image/png', 'image/gif', 'image/pjpeg', 'image/x-png']


  #attached
  has_attached_file :photo, {:styles => { :normal => "643x253!" }, :url => "/shared/articles/:attachment/:id/:style_:basename.:extension", :path => ":rails_root/public:url"}


  #Associations
  belongs_to :user
  has_many :comments, :foreign_key => :external_id, :conditions => "external_type = '#{Article.to_s}'"

  #Scopes
  scope :published, where(:published => true)
  scope :featured, where(:featured => true)
  scope :recent, order("articles.id desc").limit(20)
  scope :latest, order("articles.id desc").limit(1)
  scope :newest, order("articles.id desc")

  def self.paginated(page=1,offset=20)
    newest.limit(offset).offset((page - 1) * offset)
  end

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
    self.description.bbcode_to_html(Sc2sl::Application::CUSTOM_BBCODE) #.bbcode_to_html({}, false, :disable, false)
  end


end
