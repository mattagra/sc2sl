class RemoveActiveFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :active
  end

  def down
    addcolumn :users, :active, :boolean, :default => false, :null => false
  end
end
