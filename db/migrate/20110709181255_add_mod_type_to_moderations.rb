class AddModTypeToModerations < ActiveRecord::Migration
  def self.up
    rename_column :moderations, :type, :mod_type
  end

  def self.down
    rename_column :moderations, :mod_type, :type
  end
end
