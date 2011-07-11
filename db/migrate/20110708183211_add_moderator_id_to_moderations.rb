class AddModeratorIdToModerations < ActiveRecord::Migration
  def self.up
    add_column :moderations, :moderator_id, :integer
  end

  def self.down
    remove_column :moderations, :moderator_id
  end
end
