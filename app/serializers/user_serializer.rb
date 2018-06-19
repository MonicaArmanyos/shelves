class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :rate, :facebook_page, :phone, :address, :profile_picture
  def phone
    id_user=object.id
    Phone.where(:user_id => id_user).select(["phone"])
  end 
  def address
    id_user=object.id
    Address.where(:user_id => id_user).select(Address.column_names)
  end
end
