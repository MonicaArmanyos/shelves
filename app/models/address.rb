class Address < ApplicationRecord
  validates :building_number, :street, :region ,:city, presence: true, if: :postal_code?
  validates :building_number, :street, :region ,:postal_code, presence: true, if: :city?
  validates :building_number, :street, :postal_code ,:city, presence: true, if: :region?
  validates :building_number, :postal_code, :region ,:city, presence: true, if: :street?
  validates :postal_code, :street, :region ,:city, presence: true, if: :building_number?
  belongs_to :user
end
