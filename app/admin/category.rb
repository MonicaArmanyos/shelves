ActiveAdmin.register Category do
    permit_params :name
    scope :all,default: true
    scope :created_this_week do |tasks|
      tasks.where('created_at <= ? and created_at >= ?', Time.now, 1.week.ago)
    end
    scope :created_2_days_ago do |tasks|
      tasks.where('created_at < ? and created_at >= ?', Time.now, 2.days.ago)
    end
    config.per_page =9
    
    show do
      attributes_table do
        row :name
      end 
      attributes_table do
        row :created_at
        row :updated_at
      end  
      active_admin_comments
    end
  end    