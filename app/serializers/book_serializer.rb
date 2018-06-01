class BookSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :rate, :quantity, :price, :is_approved, :transcation, :bid_user, :category, :user
  #belongs_to :category
#belongs_to :user

end
