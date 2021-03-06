class AddFacebookConnectFieldsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :facebook_session_key, :string
    add_column :users, :facebook_uid, :integer
  end

  def self.down
    remove_column :users, :facebook_uid
    remove_column :users, :facebook_session_key
  end
end
