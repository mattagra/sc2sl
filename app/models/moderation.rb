class Moderation < ActiveRecord::Base

  #STATIC
  TYPES = ["warned", "banned", "permabanned"]

  #Associations
  belongs_to :user
  belongs_to :comment
  belongs_to :moderator, :class_name => "User"

  #Validations
  validates :comment_id, :presence => true, :uniqueness => true
  validates :moderator_id, :presence => true
  validates :mod_type, :presence => true, :inclusion => {:in => TYPES}
  validates :reason, :presence => true, :legnth => {:minimum => 3, :maximum => 256}


  def ends_at
    self.created_at + self.length.to_i.days
  end

end
