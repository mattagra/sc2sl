class CreateVoteEvents < ActiveRecord::Migration
  def self.up
    create_table :vote_events do |t|
      t.integer :match_id
      t.datetime :started_at
      t.datetime :ended_at
      t.integer :team_id

      t.timestamps
    end
  end

  def self.down
    drop_table :vote_events
  end
end
