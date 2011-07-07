class AddBannerToSeasons < ActiveRecord::Migration
  def self.up
    add_column :seasons, :banner_file_name, :string
    add_column :seasons, :banner_content_type, :string
    add_column :seasons, :banner_file_size, :integer
    add_column :seasons, :published, :boolean
  end

  def self.down
    remove_column :seasons, :banner_file_size
    remove_column :seasons, :banner_content_type
    remove_column :seasons, :banner_file_name
    remove_column :seasons, :published
  end
end
