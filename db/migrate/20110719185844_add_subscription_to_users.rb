class AddSubscriptionToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :subscription, :boolean
    remove_column :users, :team_name
  end

  def self.down
    remove_column :users, :subscription
    add_column :users, :team_name, :string
  end
end
