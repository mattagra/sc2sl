class AddFieldsToMatches < ActiveRecord::Migration
  def self.up
    add_column :matches, :season_id, :integer
    add_column :matches, :playoff_id, :integer
    add_column :matches, :weeks_id, :integer
    add_column :matches, :scheduled_at, :datetime
    add_column :matches, :best_of, :integer
    add_column :matches, :results, :integer #anywhere from 4-0 to 0-4
    add_column :seasons, :playoff_teams, :integer #Number of teams in playoffs
  end

  def self.down
  end
end
