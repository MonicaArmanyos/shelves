class AddDefaultValueToRate < ActiveRecord::Migration[5.1]
  def change
    change_column :books, :rate, :integer, default: 0
    change_column :users, :rate, :integer, default: 0
    change_column :rates, :rate, :integer, default: 0
    change_column :user_rates, :rate, :integer, default: 0
  end
end
