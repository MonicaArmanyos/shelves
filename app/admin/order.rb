ActiveAdmin.register Order do
  permit_params :book_id, :user_id, :seller_id, :state, :transcation, :price
  scope :all,default: true
  scope :created_this_week do |tasks|
    tasks.where('created_at <= ? and created_at >= ?', Time.now, 1.week.ago)
  end
  scope :created_2_days_ago do |tasks|
    tasks.where('created_at < ? and created_at >= ?', Time.now, 2.days.ago)
  end
  config.per_page =6

  index do
    selectable_column
    id_column
    column :user
    column :book
    column :seller
    column :state 
    column :transcation
    column :price
    column :created_at
    actions
  end  

  show do |order|
    attributes_table do
      row :user 
      row :book
    end  
    attributes_table do
      row :seller
      row :quantity
    end  
    attributes_table do
      row :state 
      row :transcation
      if ((order.transcation.eql? "Sell" )|| (order.transcation.eql? "Sell By Bid"))
        row :price do 
          order.price * order.quantity
        end  
      end  
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
      f.input :state 
      f.input :transcation
    end 
    f.inputs do 
      f.input :seller
      f.input :price
    end  
    f.actions 
  end 
  
  filter :user
  filter :book
  filter :seller
  filter :state
  filter :transcation  
  filter :price 
  filter :updated_at
  filter :created_at
end    