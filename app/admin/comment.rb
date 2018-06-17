ActiveAdmin.register Comment do
  permit_params :comment, :user_id, :book_id, replies_attributes: [:id, :reply, :user_id, :_destroy]
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
    column :comment do |comment|
      truncate(comment.comment, omision: "...", length: 20) 
    end  
    column :user
    column :book
    column :created_at
    column :updated_at
    actions
  end  
  
  show do |comment|
    attributes_table do
      row :comment
    end 
    attributes_table do
      row :user
      row :book
    end 
    attributes_table do
      row :created_at
      row :updated_at
    end  
    panel 'Replies' do
      table_for comment.replies.each do |t|  
        t.column :reply
        t.column :user
        t.column :created_at
        t.column :updated_at
      end  
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
    f.has_many :replies do |reply|
      if reply.object.new_record?
        reply.inputs :reply
        reply.inputs :user
      else
        reply.inputs :reply
        reply.inputs :user
        reply.input :_destroy, as: :boolean, required: :false, label: 'Remove reply'
      end  
    end  
    f.actions
  end
end    