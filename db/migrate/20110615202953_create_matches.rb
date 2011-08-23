class CreateMatches < ActiveRecord::Migration
  def self.up
    create_table :matches do |t|
      t.integer :team0_id
      t.integer :team1_id

      t.timestamps
    end
  end

  def self.down
    drop_table :matches
  end
end
