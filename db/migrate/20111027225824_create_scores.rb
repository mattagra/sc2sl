class CreateScores < ActiveRecord::Migration
  def self.up
    create_table :scores do |t|
      t.integer :user_id

      t.timestamps
    end
    add_index :scores, :user_id
  end

  def self.down
    drop_table :scores
  end
end
