class CreateUserPhones < ActiveRecord::Migration[5.1]
  def change
    create_table :user_phones do |t|
      t.references :user, foreign_key: true
      t.string :phone
    end
  end
end
