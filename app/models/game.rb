class Game < ActiveRecord::Base
  belongs_to :map
  belongs_to :match
end
