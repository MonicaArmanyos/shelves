class NotificationMessageSerializer < ActiveModel::Serializer
  attributes :id , :title, :body , :click_action , :icon , :receiver_user ,:sender_user ,:created_at
 
  def receiver_user
    id_receiveruser=object.receiver_user
    User.where(:id => id_receiveruser).select(User.column_names - ["password_digest","email_confirmed","confirm_token","created_at","updated_at","password_reset_token","password_reset_sent_at"])

  end 

  def sender_user
    id_user=object.sender_user
    User.where(:id => id_user).select(User.column_names - ["password_digest","email_confirmed","confirm_token","created_at","updated_at","password_reset_token","password_reset_sent_at"])

  end 

  def created_at
    object.created_at.strftime("%B %e, %Y at %I:%M %p")
  end
end
