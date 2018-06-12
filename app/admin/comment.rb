ActiveAdmin.register Comment do
  permit_params :comment, :user_id, :book_id
  scope :all,default: true
  config.per_page =9
  
  show do |comment|
    attributes_table do
      row :comment
    end 
    attributes_table do
      row :user
      row :book
    end 
    attributes_table do
      row :like
    end
    attributes_table do
      row :created_at
      row :updated_at
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
      f.input :comment
    end
    f.actions
  end
end    