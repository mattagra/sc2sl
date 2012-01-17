class AddAdminRatingToGames < ActiveRecord::Migration
  def self.up
    add_column :games, :admin_rating, :integer,  :default => 0
  end

  def self.down
    remove_column :games, :admin_rating
  end
end
