class CreateNotificationTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :notification_tokens do |t|
      t.string :token
      t.references :user, index: true
      t.timestamps
    end
  end
end
