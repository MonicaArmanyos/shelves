class RemoveColumnSellerFromOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :seller, :integer
  end
end
