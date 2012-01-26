class AddHtmlTextToAdvertisement < ActiveRecord::Migration
  def self.up
    add_column :advertisements, :html_text, :text, :limit => 512
  end

  def self.down
    remove_column :advertisements, :html_text
  end
end
