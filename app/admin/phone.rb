ActiveAdmin.register Phone do
    permit_params :phone, :user_id
    scope :all,default: true
    config.per_page =9
     
   show do |phone|
     attributes_table do
       row :phone
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
       f.input :phone
     end  
     f.actions
   end  
 end  