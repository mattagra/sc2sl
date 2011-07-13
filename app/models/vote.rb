class Vote < ActiveRecord::Base
  belongs_to :vote_event
  belongs_to :user
  belongs_to :player
  


  validates :user_id,  :presence => true, :uniqueness => {:scope => :vote_event_id}
  validates :vote_event, :presence => true
  validates :player, :presence => true
  validates :ip_address, :presence => true, :uniqueness => {:scope => :vote_event_id}
  validate :validates_running_vote_event

   def validates_running_vote_event
     unless Time.now > self.vote_event.started_at and Time.now < self.vote_event.ended_at
       errors.add :base, "Live Voting has Finished"
     end
   end




end
