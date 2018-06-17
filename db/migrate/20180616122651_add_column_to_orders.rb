class AddColumnToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :notification_sent, :boolean
  end
end
