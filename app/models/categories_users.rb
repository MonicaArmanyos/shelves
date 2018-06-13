class CategoriesUsers < ApplicationRecord
    #### Relations ####
    belongs_to :category
    belongs_to :user 
end 