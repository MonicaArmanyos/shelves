class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :profile_picture
      t.integer :role
      t.string :gender, :null => true
      t.integer :rate
      t.boolean :email_confirmed,:default => false
      t.string :confirm_token

      t.timestamps
    end
  end
end
