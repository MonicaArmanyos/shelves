class DropUserPhones < ActiveRecord::Migration[5.1]
  def change
    drop_table :user_phones
  end
end
