class WorkSpace < ApplicationRecord
    has_many :work_space_phones, dependent: :destroy
    accepts_nested_attributes_for :work_space_phones, :reject_if => lambda { |param| param[:phone].blank? }, allow_destroy: true
    mount_uploader :picture, ProfilePictureUploader
end
