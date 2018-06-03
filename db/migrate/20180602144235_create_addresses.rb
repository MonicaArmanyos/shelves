class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.references :user, foreign_key: true
      t.integer :building_number
      t.string :street
      t.string :region
      t.string :city
      t.integer :postal_code

      t.timestamps
    end
  end
end
