class BookSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :rate, :quantity, :price, :is_approved, :transcation, :user_bid, :category, :user, :book_images , :bid_duration

 #### get bid_user object
  def user_bid
    id_biduser=object.bid_user
    User.where(:id => id_biduser).select(User.column_names - ["password_digest","email_confirmed","confirm_token","created_at","updated_at","password_reset_token","password_reset_sent_at"])

  end 

  def user
    id_user=object.user_id
    User.where(:id => id_user).select(User.column_names - ["password_digest","email_confirmed","confirm_token","created_at","updated_at","password_reset_token","password_reset_sent_at"])

  end 

  

  
end
