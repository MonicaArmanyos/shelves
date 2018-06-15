ActiveAdmin.register User do
  permit_params :name,:email, :role, :gender, :rate, :profile_picture, :password, :password_confirmation, phones_attributes: [:id, :phone, :_destroy], addresses_attributes: [:id, :building_number, :street, :region, :city, :postal_code, :_destroy]
    scope :all,default: true
    scope :created_this_week do |tasks|
      tasks.where('created_at <= ? and created_at >= ?', Time.now, 1.week.ago)
    end
    scope :created_2_days_ago do |tasks|
      tasks.where('created_at < ? and created_at >= ?', Time.now, 2.days.ago)
    end
    config.per_page =9

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
        row :gender
        row :profile_picture do |user|
          image_tag user.profile_picture.url, size: "140x140" if user.profile_picture?
        end  
      end  
      attributes_table do
        row :email
        if user.role.eql? "Normal user"
          row :gender
        end  
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
      panel 'Interests' do
        table_for user.categories.each do |t|
          t.column :name
          t.column :created_at
          t.column :updated_at
        end   
      end  
      panel 'Phones' do
        table_for user.phones.each do |t|  
          t.column :phone 
          t.column :created_at
          t.column :updated_at
        end  
      end  
      panel 'Addresses' do
        table_for user.addresses.each do |t|
          t.column :building_number
          t.column :street
          t.column :region
          t.column :city
          t.column :postal_code
          t.column :created_at
          t.column :updated_at
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
          if f.object.role.eql? "Normal user"
            f.input :gender
          end  
          f.input :rate  
          f.input :profile_picture
          f.has_many :phones do |phone|
            if phone.object.new_record?
              phone.inputs :phone
            else
              phone.input :phone
              phone.input :_destroy, as: :boolean, required: :false, label: 'Remove phone'
            end  
          end  
          f.has_many :addresses do |address|
            if address.object.new_record?
              address.inputs :building_number 
              address.inputs :street
              address.inputs :region 
              address.inputs :city
              address.inputs :postal_code
            else
              address.input :building_number 
              address.input :street
              address.input :region 
              address.input :city
              address.input :postal_code
              address.input :_destroy, as: :boolean, required: :false, label: 'Remove phone'

            end  
          end  
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
  