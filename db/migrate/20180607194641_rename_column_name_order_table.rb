class RenameColumnNameOrderTable < ActiveRecord::Migration[5.1]
  def change
    rename_column :orders, :type, :transcation
  end
end
