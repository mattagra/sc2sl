class Team < ActiveRecord::Base
  belongs_to :country
  belongs_to :user

    has_many :comments, :foreign_key => :external_id, :conditions => "external_type = '#{Team.to_s}'"


  def to_s
    self.name
  end
end
