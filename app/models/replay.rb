class Replay < ApplicationRecord

  #### Relations ####
  belongs_to :user
  belongs_to :comment  
end
