class AddPhotoToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :photo_file_name, :string
    add_column :articles, :photo_content_type, :string
    add_column :articles, :photo_file_size, :integer
  end

  def self.down
    remove_column :articles, :photo_file_size
    remove_column :articles, :photo_content_type
    remove_column :articles, :photo_file_name
  end
end
