class Player < ActiveRecord::Base
  belongs_to :team
  belongs_to :user

    has_many :comments, :foreign_key => :external_id, :conditions => "external_type = '#{Player.to_s}'"

  def login
    self.user.login if self.user
  end

  def to_s
    self.login if self.login
  end


end
