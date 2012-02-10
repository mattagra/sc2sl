class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :topics do |t|
      t.references :forum
      t.references :user
      t.string :subject
      t.boolean :hidden, :default => false
      t.boolean :pinned, :default => false
      t.boolean :locked, :default => false
      t.integer :views, :default => 0

      t.timestamps
    end
    add_index :topics, :forum_id
    add_index :topics, :user_id
    
  end

  def self.down
    drop_table :topics
  end
end
