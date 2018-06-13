ActiveAdmin.register Replay do
  permit_params :replay, :user_id, :comment_id
  scope :all,default: true
  config.per_page =9
end
