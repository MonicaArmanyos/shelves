class DropNotificationMessagesTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :notification_messages
  end
end
