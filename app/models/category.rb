class Category < ApplicationRecord
    validates :name, presence: true
            
    #### Relations ####
has_many :books
has_and_belongs_to_many :users
end
