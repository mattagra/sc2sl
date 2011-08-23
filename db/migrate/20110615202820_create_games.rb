class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.integer :player0_id
      t.integer :player1_id
      t.integer :result
      t.integer :downloads
      t.references :map
      t.references :match
      t.integer :match_order

      t.timestamps
    end
  end

  def self.down
    drop_table :games
  end
end
