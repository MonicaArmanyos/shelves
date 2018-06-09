module Api::V1::User
  class Api::V1::User::PasswordResetsController < ApiController
    skip_before_action :authenticate_request
    def create
      user = User.find_by_email(params[:email])
      user.skip_email_validation = true
      if user
        user.send_password_reset
      end
      render json:  {status: 'SUCCESS', message: "Email sent with password reset instructions."}, status: :created
    end


    def update
      @user = User.find_by_password_reset_token!(params[:id])
      if @user.password_reset_sent_at < 2.hours.ago
        render json:  {status: 'FAIL', message: "Password reset has expired"}, status: :ok
      elsif @user.update_attributes(password_params)
        render json:  {status: 'SUCCESS', message: "Password has been reset"}, status: :ok
      else
        render json: {status: 'FAIL', message: "Please try again "}, status: :ok
      end
    end

    def password_params
      params.permit(
        :password,
        :password_confirmation, 
        
      )
    end 
  end 
end 