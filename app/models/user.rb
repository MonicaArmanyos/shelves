class User < ApplicationRecord
    has_secure_password
    before_create :confirmation_token
    enum gender: {male: "male", female: "female"}
    enum role: {"Normal user" => 0, "Book store" =>1}
    mount_uploader :profile_picture, ProfilePictureUploader

    validates :email, :password_digest, presence: true
            
    #### Relations ####
      has_many :books
      has_many :addresses, :dependent => :destroy
      has_many :phones, :dependent => :destroy
      has_and_belongs_to_many :categories

      #### accept upload multiple phones
      accepts_nested_attributes_for :phones, :allow_destroy => true
      #### accept upload multiple addresses
      accepts_nested_attributes_for :addresses, :allow_destroy => true
      

    def email_activate
        self.email_confirmed = true
        self.confirm_token = nil
        save!(:validate => false)
      end
      private 
      def confirmation_token
        if self.confirm_token.blank?
          self.confirm_token = SecureRandom.urlsafe_base64.to_s
        end
      end
end
