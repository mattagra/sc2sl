class Article < ActiveRecord::Base
  
  acts_as_url :title, :sync_url => true
  acts_as_taggable

  validates :url, :uniqueness => true
  validates :summary, :length => {:minimum => 5, :maximum => 256}

  has_attached_file :photo, {:styles => { :normal => "641x253!" }, :url => "/images/:class/:attachment/:id/:style_:basename.:extension", :path => ":rails_root/public:url"}
  has_attached_file :featured_photo, {:styles => {:normal => "524x140"}, :url => "/images/:class/:attachment/:id/:style_:basename.:extension", :path => ":rails_root/public:url"}

  belongs_to :user
  has_many :comments, :foreign_key => :external_id, :conditions => "external_type = '#{Article.to_s}'"

  scope :published, where(:published => true)
  scope :featured, where(:featured => true)
  scope :recent, order("articles.id desc").limit(20)

  scope :latest, order("articles.id desc").limit(1)

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
