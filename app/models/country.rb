class Country < ActiveRecord::Base

  validates :name, :presence => true
  validates :short, :presence => true
  


  def flag
    self.short.downcase
  end

  def to_s
    self.name
  end
  
end
