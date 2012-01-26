class Advertisement < ActiveRecord::Base
  AD_TYPES = {"horizontal" => {:width => "570", :height => "92"}, "vertical" => {:width => "120", :height => "600"}}
  
  
  #validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than=>1.megabyte
  validates_attachment_content_type :photo, :content_type=>['image/jpeg', 'image/png', 'image/gif']
  validates :ad_type, :presence => true, :inclusion =>  Advertisement::AD_TYPES.keys
  
  
  
  #scope :random_ad, lambda { order("-LOG(1.0 - RANDOM()) / weight asc")  }
  
  
  
  scope :of_type, lambda {|x| where(:ad_type => x)}
  
  

  has_attached_file :photo, {
    :styles => {:horizontal => "570x92!", :vertical => "120x600!"},
    :url => "/shared/internal_ad/:attachment/:id/:style.:extension",
    :path => ":rails_root/public:url"  
  }
  
  
  def is_html_ad?
    !self.html_text.nil? and self.html_text.length > 0
  end

end
