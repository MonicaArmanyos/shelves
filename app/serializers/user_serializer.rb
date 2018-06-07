class UserSerializer < ActiveModel::Serializer
  attributes :id
  has_many :books, serializer: BookSerializer
end
