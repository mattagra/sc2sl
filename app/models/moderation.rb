class Moderation < ActiveRecord::Base

  #STATIC
  TYPES = ["warned", "banned", "permabanned"]

  #Associations
  belongs_to :user
  belongs_to :comment
  belongs_to :moderator, :class_name => "User"

  #Validations
  validates :comment_id, :uniqueness => true
  
  validates :moderator_id, :presence => true
  validates :mod_type, :presence => true, :inclusion => {:in => TYPES}
  validates :reason, :presence => true, :length => {:minimum => 3, :maximum => 256}

  before_save :set_ends_at


  def set_ends_at
    self.ends_at = (self.created_at || Time.now) + self.length.to_i.days
  end

end
