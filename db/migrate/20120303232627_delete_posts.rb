class DeletePosts < ActiveRecord::Migration
  def self.up
    drop_table :posts
  end


  def self.down
    create_table :posts do |t|
      t.references :topic
      t.references :user
      t.text :text

      t.timestamps
    end
    add_index :posts, :topic_id
    add_index :posts, :user_id
    
  end

  
end
