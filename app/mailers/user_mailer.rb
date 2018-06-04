class UserMailer < ActionMailer::Base
    default :from => "noreply@shelves.com"
    def registration_confirmation(user)
        @user=user
        mail(:to => "#{user.name} < #{user.email}>" , :subject => "Email Confirmation")
    end


def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Password Reset"
  end
  
  
end
