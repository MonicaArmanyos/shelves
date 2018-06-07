class Rate < ApplicationRecord

    #### validate that rate must be presense and accept numbers from 1:5 ####
    validates :rate, :inclusion => 1..5 , presence: true

    #### Relations Many To Many ####
    belongs_to :user
    belongs_to :book
    
end
