class NotificationToken < ApplicationRecord
    #validates :token, uniqueness: true  
    #### Relations ####
     belongs_to :user
    
end
