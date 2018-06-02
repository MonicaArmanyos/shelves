class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.string :name
      t.text :description
      t.integer :rate 
      t.integer :quantity, default: 1
      t.float :price
      t.boolean :is_approved
      t.integer :transcation
      t.integer :bid_user
      t.references :category, index: true
      t.references :user, index: true
      t.timestamps
    end
  end
end
