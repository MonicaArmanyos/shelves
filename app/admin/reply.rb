ActiveAdmin.register Reply do
  permit_params :reply, :user_id, :comment_id
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
    column :reply do |reply|
      truncate(reply.reply, omision: "...", length: 20) 
    end  
    column :user
    column :comment do |reply|
      link_to reply.comment.comment,  admin_comment_path(reply.comment)
    end  
    column :created_at
    column :updated_at
    actions
  end  

  show do
    attributes_table do
      row :reply
      row :user
      row :comment  do |reply|
        link_to reply.comment.comment,  admin_comment_path(reply.comment)
      end    
    end   
    attributes_table do
      row :created_at
      row :updated_at    
    end   
    active_admin_comments   
  end  

  form :html => { :multipart => true } do |f|
    f.inputs do
      f.input :user
      f.input :comment
    end
    f.inputs do
      f.input :reply
    end
    f.actions
  end
end
