class VoteEvent < ActiveRecord::Base
  has_many :votes
  belongs_to :match
  belongs_to :team

  def players
    if match.team0 == team
      match.games.collect{|g| g.player0}.reject{|p| p.nil? }
    else
      match.games.collect{|g| g.player1}.reject{|p| p.nil? }
    end
  end


end
