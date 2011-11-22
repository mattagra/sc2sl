class Advertisement < ActiveRecord::Base
  AD_TYPES = {"horizontal" => {:width => "570", :height => "92"}, "vertical" => {:width => "120", :height => "600"}}
  
  
  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than=>1.megabyte
  validates_attachment_content_type :photo, :content_type=>['image/jpeg', 'image/png', 'image/gif']
  validates :ad_type, :presence => true, :inclusion =>  Advertisement::AD_TYPES.keys
  
  
  
  scope :random_ad, lambda { order("RAND() * weight")  }
  
  
  
  scope :of_type, lambda {|x| where(:ad_type => x)}
  
  

  has_attached_file :photo,    {
    :styles => {
      :horizontal => "570x92!",
      :vertical => "120x600!",
    }, 
    :url => "/shared/advertisements/:attachment/:id/:style_:basename.:extension",
    :path => ":rails_root/public:url",
  }

end
