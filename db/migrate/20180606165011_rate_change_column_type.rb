class RateChangeColumnType < ActiveRecord::Migration[5.1]
  def change
    change_column :books, :rate, :float
  end
end
