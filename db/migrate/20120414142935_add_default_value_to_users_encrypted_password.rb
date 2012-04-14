class AddDefaultValueToUsersEncryptedPassword < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.change :encrypted_password, :string, :null => false, :default => ""
      t.change :password_salt, :string, :null => false, :default => ""
    end
  end
  
  def self.down
    change_table :users do |t|
      t.change :encrypted_password, :string, :null => false, :default => ""
      t.column   :password_salt, :string,    :null => false, :default => ""
    end
  
  end
end
