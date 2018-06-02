ActiveAdmin.register Book do
  permit_params :name, :description, :user_id, :category_id, :bid_user, :transcation, :is_approved, :price, :quantity, book_images_attributes: [:id, :image, :_destroy]
  
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

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :name
      f.input :description
    end
    f.inputs do 
      f.input :user
      f.input :category
    end  
    f.inputs do
      f.input :transcation
      f.input :price
      f.input :quantity
    end  
    if :is_approved
      if f.object.new_record? || !f.object.is_approved
        f.inputs do
          f.input :is_approved
        end  
      end
    end     
    f.inputs do 
      f.has_many :book_images do |i|
        if i.object.new_record?
          i.inputs :image
        else
          i.input :image, :hint => i.template.image_tag(i.object.image.url())
          i.input :_destroy, as: :boolean, required: :false, label: 'Remove image'
        end  
      end    
    end  
    f.actions
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

