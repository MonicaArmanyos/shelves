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

  show do |book|
    attributes_table do
      row :name 
      row :description 
      row :user
      row :category
    end  
    attributes_table do
      row :quantity
      row :rate
      row :is_approved
    end 
    attributes_table do
        row :transcation
        row :price 
        row :bid_user
      end  
    attributes_table do
      row :created_at
      row :updated_at    
    end  
    active_admin_comments   
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

