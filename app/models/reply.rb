class Reply < ApplicationRecord
  
  #validation
  validates :reply, :user_id, :comment_id, presence: true
  validates :reply, length: {minimum:2}

  #### Relations ####
  belongs_to :user
  belongs_to :comment  
end
