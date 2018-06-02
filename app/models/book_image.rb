class BookImage < ApplicationRecord
    
    #### Relations ####
belongs_to :book

#### Mount image uploader
mount_uploader :image, ImageUploader
end