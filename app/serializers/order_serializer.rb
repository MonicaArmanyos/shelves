class OrderSerializer < ActiveModel::Serializer
  attributes :id, :user, :book , :seller, :state , :transcation , :price , :quantity, :exchangeable_books , :book_images
  
  def user
    id_user=object.user_id
    User.where(:id => id_user).select(User.column_names - ["password_digest","email_confirmed","confirm_token","created_at","updated_at","password_reset_token","password_reset_sent_at"])
  end 

  def seller
    id_user=object.seller_id
    User.where(:id => id_user).select(User.column_names - ["password_digest","email_confirmed","confirm_token","created_at","updated_at","password_reset_token","password_reset_sent_at"])
  end

  def book
    book_id=object.book_id
    Book.where(:id => book_id).select(["id","name","description"])
  end

  def book_images
    book_id=object.book_id
    BookImage.where(:book_id => book_id)
  end

end
