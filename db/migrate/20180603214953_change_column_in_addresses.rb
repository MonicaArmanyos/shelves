class ChangeColumnInAddresses < ActiveRecord::Migration[5.1]
  def change
    change_column :addresses, :postal_code, :string
  end
end
