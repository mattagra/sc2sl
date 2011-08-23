class CreateLiveEvents < ActiveRecord::Migration
  def self.up
    add_column :matches, :url, :string
    add_column :matches, :caster_ids, :string
    add_column :matches, :live, :boolean
  end

  def self.down
    remove_column :matches, :url
    remove_column :matches, :caster_ids
    remove_column :matches, :live
  end
end
