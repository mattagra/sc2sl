class AddEndsAtToModerations < ActiveRecord::Migration
  def self.up
    add_column :moderations, :ends_at, :datetime
  end

  def self.down
    remove_column :moderations, :ends_at
  end
end
