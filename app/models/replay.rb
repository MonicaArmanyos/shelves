class Replay < ApplicationRecord
  
  #validation
  validates :replay, :user_id, :comment_id, presence: true
  validates :replay, length: {minimum:2}

  #### Relations ####
  belongs_to :user
  belongs_to :comment  
end
