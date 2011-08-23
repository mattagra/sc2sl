class RemovePartnerIdFromSeasons < ActiveRecord::Migration
  def self.up
    remove_column :seasons, :partner_id
  end

  def self.down
    add_column :seasons, :partner_id, :integer
  end
end
