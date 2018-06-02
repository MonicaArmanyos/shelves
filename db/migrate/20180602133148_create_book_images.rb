class CreateBookImages < ActiveRecord::Migration[5.1]
  def change
    create_table :book_images do |t|
      t.string :image
      t.references :book, index: true
      t.timestamps
    end
  end
end
