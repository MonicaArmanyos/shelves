class AddPhoneToWorkSpaces < ActiveRecord::Migration[5.1]
  def change
    add_column :work_spaces, :phone, :string
  end
end
