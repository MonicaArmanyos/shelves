class AddDetailsToOrders < ActiveRecord::Migration[5.1]
  def change
    add_reference :orders, :seller, foreign_key: { to_table: :users }, after: :book_id
    add_reference :orders, :exchangeable_book, foreign_key: { to_table: :books }
  end
end
