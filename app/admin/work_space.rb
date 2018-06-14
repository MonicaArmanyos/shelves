ActiveAdmin.register WorkSpace do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

permit_params :name, :facebook,:address, :picture, work_space_phones_attributes:  [:id, :phone, :_destroy]
scope :all,default: true
   scope :created_this_week do |tasks|
    tasks.where('created_at <= ? and created_at >= ?', Time.now, 1.week.ago)
  end
  scope :late do |tasks|
    tasks.where('created_at < ? and created_at >= ?', Time.now, 2.days.ago)
  end
   config.per_page =9

form do |f|
    f.inputs 'Contacts' do
      f.input :name, label: 'Name'
      f.input :address, label: 'Address'
      f.input :facebook, label: 'Facebook'
      f.input :picture
      f.has_many :work_space_phones, allow_destroy: true do |t|
        t.input :phone 
      end
    end

    
   
    f.actions
  end

  controller do
    def scoped_collection
      super.includes(:work_space_phones)
    end
  end
  index do
    selectable_column
    id_column
    column :picture do |work_space|
      image_tag work_space.picture.url, size: "60x60" if work_space.picture?
    end
    column :name
    column :address
    column :facebook
    column 'Phone' do |work_space|
        work_space.work_space_phones.map(&:phone).join('-')
      end
    column :created_at
    column :updated_at
    actions
  end

  show do |work_space|
    attributes_table do
      row :name 
      row :picture do |workspace|
        image_tag workspace.picture.url, size: "140x140" if workspace.picture?
      end
    end  
    attributes_table do 
      row :address
      row :facebook
      row 'Phone' do |work_space|
        work_space.work_space_phones.map(&:phone).join('-')
      end
    end  
    active_admin_comments
end

end
