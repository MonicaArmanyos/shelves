class CreatePhones < ActiveRecord::Migration[5.1]
  def change
    create_table :phones do |t|
      t.references :user, foreign_key: true
      t.string :phone

      t.timestamps
    end
  end
end
