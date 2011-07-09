class Moderation < ActiveRecord::Base
  belongs_to :user
  belongs_to :comment
  belongs_to :moderator, :class_name => "User"

  TYPES = ["warned", "banned", "permabanned"]

  def ends_at
    self.created_at + self.length.to_i.days
  end

end
