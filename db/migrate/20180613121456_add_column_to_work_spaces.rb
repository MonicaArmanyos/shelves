class AddColumnToWorkSpaces < ActiveRecord::Migration[5.1]
  def change
    add_column :work_spaces, :address, :string
  end
end
