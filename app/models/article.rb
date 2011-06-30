class Article < ActiveRecord::Base
  belongs_to :user
  acts_as_url :title, :sync_url => true

  validates_uniqueness_of :url

  has_many :comments, :foreign_key => :external_id, :conditions => "external_type = '#{Article.to_s}'"

  def to_s
    self.title
  end



end
