class ReplaySerializer < ActiveModel::Serializer
  attributes :id, :user, :replay, :created_at, :comment

  def user
    id_user=object.user_id
    User.where(:id => id_user).select(User.column_names - ["password_digest","email_confirmed","confirm_token","created_at","updated_at","password_reset_token","password_reset_sent_at","email","gender","role","rate"])
  end 
  def comment
    comment_id=object.comment_id
    Comment.where(:id => comment_id).select(Comment.column_names - ["created_at","updated_at"])
  end 
  def created_at
    object.created_at = object.created_at.strftime("%B %e, %Y at %I:%M %p")
  end  

end
