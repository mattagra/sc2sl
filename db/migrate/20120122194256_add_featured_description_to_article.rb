class AddFeaturedDescriptionToArticle < ActiveRecord::Migration
  def self.up
    add_column :articles, :featured_description, :text
  end

  def self.down
    remove_column :articles, :featured_description
  end
end
