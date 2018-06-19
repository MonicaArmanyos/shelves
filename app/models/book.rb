class Book < ApplicationRecord
   
  enum transcation: {"Sell" => 0, "Free Share" =>1,"Exchange" =>2,"Sell By Bids" =>3}

    #### Relations ####
  belongs_to :category
  belongs_to :user 
  has_many :book_images, :dependent => :destroy

  has_many :rates
  has_many :users, through: :rates
  has_many :orders
  has_many :comments
  
    #### Search For Books by name & description ####
  def self.search(search)
    where("name LIKE ? OR description LIKE ?", "%#{search}%", "%#{search}%") 
  end


    #### Search For Books by Category ####
    def self.search_by_category(search)
      where("category_id LIKE ?", "%#{search}%") 
    end

 

    
    #### Mount image uploader
  #mount_uploaders :images, ImageUploader

    #### accept upload multiple images
    accepts_nested_attributes_for :book_images
end


