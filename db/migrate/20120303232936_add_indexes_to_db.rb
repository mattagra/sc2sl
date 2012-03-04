class AddIndexesToDb < ActiveRecord::Migration
  def self.up
    add_index :articles, :title
    add_index :articles, :published
	add_index :articles, :published_at
	add_index :comments, :external_id
	add_index :comments, :external_type
	add_index :comments, :user_id
	add_index :games, :player0_id
	add_index :games, :player1_id
	add_index :games, :match_id
	add_index :matches, :team0_id
	add_index :matches, :team1_id
	add_index :matches, :season_id
	add_index :matches, :weeks_id
	add_index :moderations, :user_id
	add_index :moderations, :comment_id
	add_index :players, :user_id
	add_index :players, :team_id
	add_index :users, :email
	add_index :users, :login
	add_index :users, :race
	add_index :users, [:facebook_uid, :facebook_session_key]
	add_index :users, :facebook_uid
	add_index :vote_events, :match_id
	add_index :votes, [:vote_event_id, :user_id]
	add_index :votes, [:vote_event_id, :ip_address]
	add_index :votes, :player_id
	
	
  end

  def self.down
    remove_index :articles, :title
    remove_index :articles, :published
	remove_index :articles, :published_at
	remove_index :comments, :external_id
	remove_index :comments, :external_type
	remove_index :comments, :user_id
	remove_index :games, :player0_id
	remove_index :games, :player1_id
	remove_index :games, :match_id
	remove_index :matches, :team0_id
	remove_index :matches, :team1_id
	remove_index :matches, :season_id
	remove_index :matches, :weeks_id
	remove_index :moderations, :user_id
	remove_index :moderations, :comment_id
	remove_index :players, :user_id
	remove_index :players, :team_id
	remove_index :users, :email
	remove_index :users, :login
	remove_index :users, :race
	remove_index :users, [:facebook_uid, :facebook_session_key]
	remove_index :users, :facebook_uid
	remove_index :vote_events, :match_id
	remove_index :votes, [:vote_event_id, :user_id]
	remove_index :votes, [:vote_event_id, :ip_address]
	remove_index :votes, :player_id
  end
end
