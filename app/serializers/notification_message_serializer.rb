class NotificationMessageSerializer < ActiveModel::Serializer
  attributes :id , :title, :body , :click_action , :icon , :receiver_user ,:user ,:created_at
 
  def receiver_user
    id_receiveruser=object.receiver_user
    User.where(:id => id_receiveruser).select(User.column_names - ["password_digest","email_confirmed","confirm_token","created_at","updated_at","password_reset_token","password_reset_sent_at"])

  end 

  def user
    id_user=object.user_id
    User.where(:id => id_user).select(User.column_names - ["password_digest","email_confirmed","confirm_token","created_at","updated_at","password_reset_token","password_reset_sent_at"])

  end 
end
