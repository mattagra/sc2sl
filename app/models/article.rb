class Article < ActiveRecord::Base
  belongs_to :user
  acts_as_url :title, :sync_url => true
  acts_as_taggable

  validates_uniqueness_of :url

  validates :summary, :length => {:minimum => 5, :maximum => 256}

  has_attached_file :photo,
    :styles => {
      :normal => "641x253!"
    }


  has_attached_file :featured_photo,
    :styles => {
    :normal => "524x140"
    }

  has_many :comments, :foreign_key => :external_id, :conditions => "external_type = '#{Article.to_s}'"

  def to_s
    self.title
  end

  def featured_summary
    truncate_words(self.description, 1350)
  end

  def formatted_time
    self.created_at.strftime("%B %d %Y %H:%M")
  end

  def formatted_description
    self.description.bbcode_to_html_with_formatting.bbcode_to_html({}, false, :disable)
  end



end
