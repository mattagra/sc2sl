class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :external_type
      t.integer :external_id
      t.references :user
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
