class VoteEvent < ActiveRecord::Base
  has_many :votes
  belongs_to :match

end
