class CreateModerations < ActiveRecord::Migration
  def self.up
    create_table :moderations do |t|
      t.references :user
      t.string :type
      t.integer :length
      t.string :reason

      t.timestamps
    end
  end

  def self.down
    drop_table :moderations
  end
end
