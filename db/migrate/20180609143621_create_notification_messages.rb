class CreateNotificationMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :notification_messages do |t|
      t.string :title , default: "Shelves"
      t.string :body
      t.string :click_action
      t.string :icon
      t.integer :receiver_user
      t.references :user, index: true
      t.timestamps
    end
  end
end
