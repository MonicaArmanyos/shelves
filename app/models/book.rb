class Book < ApplicationRecord
   
  enum transcation: {"Sell" => 0, "Free Share" =>1,"Exchange" =>2,"Sell By Bids" =>4}
    paginates_per 3

    #### Relations ####
  belongs_to :category
  belongs_to :user
  has_many :book_images, :dependent => :destroy

    #### Search For Books by name & description ####
  def self.search(search)
    where("name LIKE ? OR description LIKE ?", "%#{search}%", "%#{search}%") 
  end

    #### Mount image uploader
  mount_uploaders :images, ImageUploader

    #### accept upload multiple images
    accepts_nested_attributes_for :book_images
end


