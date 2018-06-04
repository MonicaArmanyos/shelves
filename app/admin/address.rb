ActiveAdmin.register Address do
   permit_params :region, :city, :street, :postal_code, :building_number, :user_id
   scope :all,default: true
   config.per_page =6
    
  show do |address|
    attributes_table do
      row :building_number
      row :street 
      row :region
      row :city
      row :postal_code
    end 
    attributes_table do
      row :user
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
    end
    f.inputs do 
      f.input :building_number
      f.input :street
      f.input :region
      f.input :city
      f.input :postal_code
    end  
    f.actions
  end  
end  