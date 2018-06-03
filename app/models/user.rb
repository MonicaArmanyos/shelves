class User < ApplicationRecord
    has_secure_password
    before_create :confirmation_token
    enum gender: {male: "male", female: "female"}
    enum role: {"Normal user" => 0, "Book store" =>1}
    mount_uploader :profile_picture, ProfilePictureUploader

    validates :email, :password_digest, presence: true

            
    #### Relations ####
      has_many :books
      has_many :user_phones
      has_and_belongs_to_many :categories
      

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
