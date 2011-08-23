class RemovePermissionLevelFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :permission_level
  end

  def self.down
    add_column :users, :permission_level, :integer
  end
end
