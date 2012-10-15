class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :title
      t.text :desc
      t.string :file

      t.timestamps
    end
  end
end
