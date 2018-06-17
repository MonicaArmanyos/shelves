class RenameRatedUserToRatedByInUserRatesChangeRateDatatype < ActiveRecord::Migration[5.1]
  def change
    rename_column :user_rates, :rated_user_id, :rated_by
    change_column :users, :rate, :float, default: 0
    change_column :books, :rate, :float, default: 0
  end
end
