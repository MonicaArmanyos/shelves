class AddDefaultValueToIsAvailableInBooks < ActiveRecord::Migration[5.1]

  def up
    change_column :books, :is_available, :boolean, default: true
  end
  
  def down
    change_column :books, :is_available, :boolean, default: nil
  end
end
