ActiveAdmin.register Order do
  permit_params :book_id, :user_id, :seller, :state, :transcation, :price
  
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
end    