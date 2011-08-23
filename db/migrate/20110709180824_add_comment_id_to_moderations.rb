class AddCommentIdToModerations < ActiveRecord::Migration
  def self.up
    add_column :moderations, :comment_id, :integer
  end

  def self.down
    remove_column :moderations, :comment_id
  end
end
