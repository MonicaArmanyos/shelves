ActiveAdmin.register Book do
  permit_params :name, :description, :user_id, :category_id, :bid_user, :transcation, :is_approved, :price, :quantity
  
  index do
    selectable_column
    id_column
    column :name
    column :description
    column :user
    column :category
    column :rate
    column :bid_user
    column :transcation
    column :is_approved
    column :price
    column :quantity
    column :created_at
    column :updated_at
    actions
  end
  filter :description
  filter :transcation
  filter :category
  filter :user
  filter :name
  filter :quantity
  filter :rate  
  filter :is_approved 
  filter :updated_at
  filter :created_at

  scope :all,default: true
  config.per_page =6
end

