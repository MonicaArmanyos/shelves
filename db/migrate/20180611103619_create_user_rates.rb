class CreateUserRates < ActiveRecord::Migration[5.1]
  def change
    create_table :user_rates do |t|
      t.references :user, foreign_key: true
      t.references :rated_user, foreign_key: {to_table: :users}
      t.integer :rate

      t.timestamps
    end
  end
end
