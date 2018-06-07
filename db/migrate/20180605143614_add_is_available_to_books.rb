class AddIsAvailableToBooks < ActiveRecord::Migration[5.1]
  def change
    add_column :books, :is_available, :boolean
  end
end
