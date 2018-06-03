class BookSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :rate, :quantity, :price, :is_approved, :transcation, :user_bid, :category, :user

 #### get bid_user object
  def user_bid
    id_biduser=object.bid_user
    User.where(:id => id_biduser)
  end 
end
