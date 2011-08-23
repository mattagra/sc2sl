class Rate < ActiveRecord::Base

  #Associations
  belongs_to :rater, :class_name => "User"
  belongs_to :rateable, :polymorphic => true

  #Attributes
  attr_accessible :rate, :dimension

  #Validations
  validates :rater_id, :presence => true, :numericality => true
  validates :rateable_id, :presence => true
  validates :rateable_type, :presence => true
  validates :stars, :presence => true, :numericality => true

end
