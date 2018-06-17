class AddIsSeenToNotificationMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :notification_messages, :is_seen, :boolean, default: 0 
  end
end
