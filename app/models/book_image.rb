class BookImage < ApplicationRecord
    
    #### Relations ####
    belongs_to :book

    #### Mount image uploader
    mount_base64_uploader :image, ImageUploader
end
