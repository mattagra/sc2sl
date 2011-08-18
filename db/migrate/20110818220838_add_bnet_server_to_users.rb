class AddBnetServerToUsers < ActiveRecord::Migration
  def self.up


    add_column :users, :bnet_server, :string


  end

  def self.down


    remove_column :users, :bnet_server


  end
end
