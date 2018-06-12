class OrderSerializer < ActiveModel::Serializer
  attributes :id, :user, :book , :seller, :state , :transcation , :price , :quatity
end
