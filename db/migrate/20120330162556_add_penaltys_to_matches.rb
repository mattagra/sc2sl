class AddPenaltysToMatches < ActiveRecord::Migration
  def self.up
    add_column :matches, :forfeit_team_id, :integer
    add_column :matches, :bonus_points0, :integer
    add_column :matches, :bonus_points1, :integer
    add_column :matches, :match_notes, :text
  end

  def self.down
    remove_column :matches, :forfeit_team_id
    remove_column :matches, :bonus_points0
    remove_column :matches, :bonus_points1
    remove_column :matches, :match_notes
  end
end
