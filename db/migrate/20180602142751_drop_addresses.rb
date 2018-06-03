class DropAddresses < ActiveRecord::Migration[5.1]
  def change
    drop_table :addresses
  end
end
t.references :user, foreign_key: true
t.integer :building_number
t.string :street
t.string :region
t.string :city
t.integer :postal_code