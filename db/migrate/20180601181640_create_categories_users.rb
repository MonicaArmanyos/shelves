class CreateCategoriesUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :categories_users do |t|
      t.belongs_to :user, index: true
      t.belongs_to :category, index: true
    end
  end
end
