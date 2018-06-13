class Comment < ApplicationRecord

  #validation
  validates :comment, :user_id, :book_id, presence: true
  validates :comment, length: {minimum:2}
    #### Relations ####
  belongs_to :user
  belongs_to :book
end
