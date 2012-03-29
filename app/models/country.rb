class Country < ActiveRecord::Base

  validates :name, :presence => true
  validates :short, :presence => true
  


  def flag
    "flags/#{self.short.downcase}.png"
  end

  def to_s
    self.name
  end
  
end
