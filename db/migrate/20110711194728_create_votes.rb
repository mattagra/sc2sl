class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :match_id
      t.integer :player_id
      t.integer :user_id
      t.integer :ip_address

      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end
