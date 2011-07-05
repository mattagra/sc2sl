class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string    :email,               :null => false, :unique => true                # optional, you can use login instead, or both
      t.string    :crypted_password,    :null => false                # optional, see below
      t.string    :password_salt,       :null => false                # optional, but highly recommended
      t.string    :persistence_token,   :null => false                # required
      t.string    :single_access_token, :null => false                # optional, see Authlogic::Session::Params
      t.string    :perishable_token,    :null => false                # optional, see Authlogic::Session::Perishability
      t.string    :login,               :null => false, :unique => true
      # Magic columns, just like ActiveRecord's created_at and updated_at. These are automatically maintained by Authlogic if they are present.
      t.integer   :login_count,         :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
      t.integer   :failed_login_count,  :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
      t.datetime  :last_request_at                                    # optional, see Authlogic::Session::MagicColumns
      t.datetime  :current_login_at                                   # optional, see Authlogic::Session::MagicColumns
      t.datetime  :last_login_at                                      # optional, see Authlogic::Session::MagicColumns
      t.string    :current_login_ip                                   # optional, see Authlogic::Session::MagicColumns
      t.string    :last_login_ip                                      # optional, see Authlogic::Session::MagicColumns
      t.boolean   :active,               :null => false, :default => false #0 for new, 1 for active 2 for admin
      t.datetime  :last_updated
      t.string    :first_name, :null => false
      t.string    :last_name, :null => false
      t.date      :birthdate
      t.string    :race #protoss, terran, zerg, random
      t.text      :profile_text
      t.string    :bnet_name
      t.integer   :bent_code
      t.integer   :bnet_id
      t.text      :signature
      t.integer   :country_id
      t.integer    :permission_level #0 for banned, 1 for normal, 2 for news moderation, 3 for match moderation, 4 for super admin
      t.boolean   :caster
      t.string    :team_name
      t.string    :website
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
