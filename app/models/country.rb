class Country < ActiveRecord::Base


  def flag
    "/images/flags/#{self.short.downcase}.png"
  end

  def to_s
    self.name
  end
  
end
