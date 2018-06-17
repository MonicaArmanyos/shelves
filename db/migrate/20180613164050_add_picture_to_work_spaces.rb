class AddPictureToWorkSpaces < ActiveRecord::Migration[5.1]
  def change
    add_column :work_spaces, :picture, :string
  end
end
