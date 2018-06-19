class AddExchangeableBooksToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :exchangeable_books, :string
  end
end
