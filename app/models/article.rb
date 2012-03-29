class Article < ActiveRecord::Base

  #Acts as
  acts_as_url :title, :sync_url => true
  acts_as_taggable

  #Validations
  validates :url, :uniqueness => true
  validates :summary, :length => {:minimum => 5, :maximum => 128}
  validates :description, :length => {:minimum => 5}
  #validates_attachment_presence :photo                    
  validates_attachment_size :photo, :less_than=>1.megabyte
  validates_attachment_content_type :photo, :content_type=>['image/jpeg', 'image/png', 'image/gif', 'image/pjpeg', 'image/x-png']

  validates :user, :presence => true
  validates :published_at, :presence => true
  

  #attached
  has_attached_file :photo, {:styles => { :normal => "643x253!" }, :url => "/shared/articles/:attachment/:id/:style_:basename.:extension", :path => ":rails_root/public:url"}


  #Associations
  belongs_to :user
  has_many :comments, :foreign_key => :external_id, :conditions => "external_type = '#{Article.to_s}'", :dependent => :destroy

  #Scopes
<<<<<<< HEAD
  scope :published, where(:published => true).where("published_at < ?", DateTime.now)
=======
  scope :published, where(:published => true).where("published_at < ?", DateTime.now.to_s(:db))
>>>>>>> 03ff8f4da78f4409d5298fd1ec66dc0ef5d02982
  scope :unpublished, where(:published => false)
  scope :featured, where(:featured => true)
  scope :recent, order("published_at desc").limit(20)
  scope :latest, order("published_at desc").limit(1)
  scope :newest, order("published_at desc")

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
    if self.published_at
      self.published_at.strftime("%B %d %Y %H:%M")
    else
      Time.now.strftime("%B %d %Y %H:%M")
    end
  end

  def formatted_description
    self.description.bbcode_to_html(Sc2sl::Application::CUSTOM_BBCODE) #.bbcode_to_html({}, false, :disable, false)
  end
  
  def commentable(user)
    true
  end


end
