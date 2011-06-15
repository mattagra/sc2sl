class Stream < ActiveRecord::Base
  belongs_to :country
  belongs_to :user
  belongs_to :match
end
