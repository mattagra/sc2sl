class Advertisement < ActiveRecord::Base
  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than=>1.megabyte
  validates_attachment_content_type :photo, :content_type=>['image/jpeg', 'image/png', 'image/gif']

  has_attached_file :photo,    {
    :styles => {
      :normal => "209x64!",
      :normal_gray => "209x64!",
    }, 
    :url => "/shared/:class/:attachment/:id/:style_:basename.:extension",
    :path => ":rails_root/public:url",
    :convert_options => {
      :normal_gray => "-colorspace gray"
    }
  }

end
