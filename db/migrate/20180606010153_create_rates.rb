class CreateRates < ActiveRecord::Migration[5.1]
  def change
    create_table :rates do |t|
      t.belongs_to :user, index: true
      t.belongs_to :book, index: true
      t.integer :rate
      t.timestamps
    end
  end
end
