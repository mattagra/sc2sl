class VoteEvent < ActiveRecord::Base

  #Associations
  has_many :votes, :dependent => :destroy
  belongs_to :match
  belongs_to :team

  def players
    if match.team0 == team
      match.games.collect{|g| g.player0}.reject{|p| p.nil? }.uniq
    else
      match.games.collect{|g| g.player1}.reject{|p| p.nil? }.uniq
    end
  end

  def current_winner
    tcount = 0
    tplayer = nil
    self.players.each do |player|
      count = self.votes.where(:player_id => player.id).count
      if count > tcount
        tcount = count
        tplayer = player
      end
    end
    tplayer
  end


end
