class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.references :user, foreign_key: true, index: true
      t.references :book, foreign_key: true, index: true     
      t.text :comment
      t.integer :like
      t.timestamps
    end
  end
end
