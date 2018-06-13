ActiveAdmin.register Reply do
  permit_params :reply, :user_id, :comment_id
  scope :all,default: true
  config.per_page =9
  
end
