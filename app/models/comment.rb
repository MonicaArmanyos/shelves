class Comment < ApplicationRecord

    #### Relations ####
  belongs_to :user
  belongs_to :book
end
