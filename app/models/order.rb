class Order < ApplicationRecord

  enum state: {"under confirmed" => 0, "confirmed" => 1}
  enum transcation: {"Sell" => 0, "Free Share" =>1,"Exchange" =>2,"Sell By Bids" =>3}
    
    #### Relations ####
  belongs_to :user
  belongs_to :seller, class_name: 'User', foreign_key: 'seller_id'
  belongs_to :book
end
