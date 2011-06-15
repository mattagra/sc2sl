class CreateGameRatings < ActiveRecord::Migration
  def self.up
    create_table :game_ratings do |t|
      t.references :user
      t.references :game
      t.integer :rating

      t.timestamps
    end
  end

  def self.down
    drop_table :game_ratings
  end
end
