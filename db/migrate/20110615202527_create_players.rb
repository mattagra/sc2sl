class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.references :team
      t.references :user
      t.date :date_joined
      t.date :date_quit

      t.timestamps
    end
  end

  def self.down
    drop_table :players
  end
end
