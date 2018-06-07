class BookSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :rate, :quantity, :price, :is_approved, :transcation, :user_bid, :category, :user
  has_one :user, serializer: UserSerializer
 #### get bid_user object
  def user_bid
    id_biduser=object.bid_user
    User.where(:id => id_biduser).select(User.column_names - ["password_digest"])

  end 

  def user
    id_user=object.user_id
    User.where(:id => id_user).select(User.column_names - ["password_digest"])

  end 
end
