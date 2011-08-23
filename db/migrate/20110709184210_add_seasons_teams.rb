class AddSeasonsTeams < ActiveRecord::Migration
  def self.up
    create_table :seasons_teams, :id => false do |t|
      t.integer :season_id
      t.integer :team_id
    end

  end

  def self.down
    drop_table :seasons_teams
  end
end
