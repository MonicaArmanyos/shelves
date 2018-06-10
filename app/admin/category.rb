ActiveAdmin.register Category do
    permit_params :name
    scope :all,default: true
    config.per_page =9
  end    