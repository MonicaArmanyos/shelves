ActiveAdmin.register User do
    permit_params :name,:email, :role, :gender, :rate, :profile_picture, :password, :password_confirmation
    scope :all,default: true
    config.per_page =6

    index do
      selectable_column
      id_column
      column :profile_picture do |user|
        image_tag user.profile_picture.url, size: "60x60" if user.profile_picture?
      end
      column :name
      column :email
      column :gender
      column :role
      column :rate
      column :created_at
      column :updated_at
      column :email_confirmed 
      actions
    end
    
    show do |user|
      attributes_table do
        row :name 
        row :profile_picture do |user|
          image_tag user.profile_picture.url, size: "140x140" if user.profile_picture?
        end  
      end  
      attributes_table do
        row :email
        row :gender
        row :role
        row :rate 
      end 
      attributes_table do
        row :created_at
        row :updated_at    
      end    
      attributes_table do
        row :email_confirmed 
      end  
      attributes_table do
        user.user_phones.each do |phone|
          row :phone do
            phone.phone
          end  
        end
      end  
      active_admin_comments   
    end 
  
    form :html => { :multipart => true } do |f|
      f.inputs do
        f.input :name
        f.input :email
      end
      f.inputs do  
        if f.object.new_record?
          f.input :role
          f.input :password
          f.input :password_confirmation
        else
          f.input :gender
          f.input :rate  
          f.input :profile_picture
        end
      end
      f.actions
    end
    scope :all,default: true
    config.per_page =6
  
    filter :email
    filter :name
    filter :gender
    filter :role
    filter :rate  
    filter :email_confirmed 
    filter :updated_at
    filter :created_at
  
  end    
  