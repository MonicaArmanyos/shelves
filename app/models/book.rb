class Book < ApplicationRecord
    enum transcation: {"Sell" => 0, "Free Share" =>1,"Exchange" =>2,"Sell By Bids" =>4}
    
    #### Relations ####
belongs_to :category
belongs_to :user
belongs_to :user, :class_name => 'User', :foreign_key => 'bid_user'

has_many :book_images

    #### Search For Books by name & description ####
def self.search(search)
    where("name LIKE ? OR description LIKE ?", "%#{search}%", "%#{search}%") 
end

    #### Mount image uploader
mount_uploaders :images, ImageUploader

end
