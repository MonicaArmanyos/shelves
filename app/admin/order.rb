ActiveAdmin.register Order do
  permit_params :book_id, :user_id, :seller, :state, :transcation, :price
  scope :all,default: true
  config.per_page =9

  index do
    selectable_column
    id_column
    column :user
    column :book
    column :seller
    column :state
    column :transcation
    column :price
    column :created_at
    column :updated_at
    actions
  end  

  show do |user|
    attributes_table do
      row :user 
      row :book
    end  
    attributes_table do
      row :seller 
      row :price
    end  
    attributes_table do
      row :state 
      row :transcation
    end  
    active_admin_comments
  end  

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :user
      f.input :book
    end
    f.inputs do
      f.input :state 
      f.input :transcation
    end 
    f.inputs do 
      f.input :seller
      f.input :price
    end  
    f.actions 
  end 
  
  filter :user
  filter :book
  filter :seller
  filter :state
  filter :transcation  
  filter :price 
  filter :updated_at
  filter :created_at
end    