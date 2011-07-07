class AddReplayToGames < ActiveRecord::Migration
  def self.up
    add_column :games, :replay_file_name, :string
    add_column :games, :replay_content_type, :string
    add_column :games, :replay_file_size, :integer
  end

  def self.down
    remove_column :games, :replay_file_size
    remove_column :games, :replay_content_type
    remove_column :games, :replay_file_name
  end
end
