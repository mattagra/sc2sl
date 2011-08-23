class AddLockedToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :locked, :boolean, :default => false
  end

  def self.down
    remove_column :comments, :locked
  end
end
