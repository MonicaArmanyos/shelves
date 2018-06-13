class RenameColumnEmailInWorkSpaces < ActiveRecord::Migration[5.1]
  def change
    rename_column :work_spaces, :email, :facebook
  end
end
