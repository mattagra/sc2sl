class AddRevivedToMatches < ActiveRecord::Migration
  def self.up
    add_column :games, :revived, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :games, :revived
  end
end
