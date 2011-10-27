class CreateBets < ActiveRecord::Migration
  def self.up
    create_table :bets do |t|
      t.string :bet
      t.integer :match_id
      t.integer :user_id
      t.integer :bet_score
      t.integer :bet_team_id
      t.integer :bet_player_id

      t.timestamps
    end
    add_index :bets, :match_id
    add_index :bets, :user_id
    add_index :bets, :bet_team_id
    add_index :bets, :bet_player_id
  end

  def self.down
    drop_table :bets
  end
end
