class AddModTypeToModerations < ActiveRecord::Migration
  def self.up
    add_column :moderations, :mod_type, :string
  end

  def self.down
    remove_column :moderations, :mod_type
  end
end
