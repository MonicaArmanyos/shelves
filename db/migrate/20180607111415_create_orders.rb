class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true, index: true
      t.references :book, foreign_key: true, index: true     
      t.integer :seller
      t.integer :state
      t.integer :type
      t.float :price
      t.timestamps
    end
  end
end
