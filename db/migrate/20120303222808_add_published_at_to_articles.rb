class AddPublishedAtToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :published_at, :datetime
	Article.reset_column_information
	Article.all.each do |a|
	  a.published_at = a.created_at
	  a.save!
	end
  end

  def self.down
    remove_column :articles, :published_at, :datetime
  end
end
