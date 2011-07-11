class Player < ActiveRecord::Base
  belongs_to :team
  belongs_to :user

    has_many :comments, :foreign_key => :external_id, :conditions => "external_type = '#{Player.to_s}'"

  def login
    self.user.login
  end


end
