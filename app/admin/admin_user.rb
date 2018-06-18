ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation
  scope :all,default: true
  scope :created_this_week do |tasks|
    tasks.where('created_at <= ? and created_at >= ?', Time.now, 1.week.ago)
  end
  scope :created_2_days_ago do |tasks|
    tasks.where('created_at < ? and created_at >= ?', Time.now, 2.days.ago)
  end

  config.per_page =10
  
  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    column :created_at
    column :remember_created_at
    actions
  end

  show do
    attributes_table do
      row :email
      row :remember_created_at
    end
    attributes_table do
      row :current_sign_in_at
      row :last_sign_in_at
      row :sign_in_count
    end 
    attributes_table do
      row :current_sign_in_ip
      row :last_sign_in_ip
    end  
    attributes_table do
      row :created_at
      row :updated_at
    end 
    active_admin_comments 
  end  
  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
