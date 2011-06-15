class CreateStreams < ActiveRecord::Migration
  def self.up
    create_table :streams do |t|
      t.string :name
      t.string :url
      t.references :country
      t.text :description
      t.references :user
      t.references :match

      t.timestamps
    end
  end

  def self.down
    drop_table :streams
  end
end
