class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :title
      t.text :desc
      t.string :file
      t.integer :page_id

      t.timestamps
    end
  end
end
