class CreateSeasonsMaps < ActiveRecord::Migration
  def self.up
    create_table :seasons_maps, :id => false do |t|
      t.integer :season_id
      t.integer :map_id
    end
  end

  def self.down
    drop_table :seasons_maps
  end
end
