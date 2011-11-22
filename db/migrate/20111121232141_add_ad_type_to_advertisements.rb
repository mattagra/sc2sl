class AddAdTypeToAdvertisements < ActiveRecord::Migration
  def self.up
    add_column :advertisements, :ad_type, :string
  end

  def self.down
    remove_column :advertisements, :ad_type
  end
end
