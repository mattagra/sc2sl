class CreateNewsletters < ActiveRecord::Migration
  def self.up
    create_table :newsletters do |t|
      t.string :subject_line
      t.text :body
      t.boolean :sent

      t.timestamps
    end
  end

  def self.down
    drop_table :newsletters
  end
end
