class AddFeaturedAndFeaturedPhotoToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :featured, :boolean
    add_column :articles, :featured_photo_file_name, :string
    add_column :articles, :featured_photo_content_type, :string
    add_column :articles, :featured_photo_file_size, :integer
  end

  def self.down
    remove_column :articles, :featured_photo_file_size
    remove_column :articles, :featured_photo_content_type
    remove_column :articles, :featured_photo_file_name
    remove_column :articles, :featured
  end
end
