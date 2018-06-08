class Api::V1::User::PasswordResetsController < ApiController
  skip_before_action :authenticate_request
  def create
    user = User.find_by_email(params[:email])
    if user
      user.send_password_reset
    end
    render :json => "Email sent with password reset instructions.".to_json, status: :created
  end


  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      render :json => "Password reset has expired".to_json, status: "No Content"
    elsif @user.update_attributes(password_params)
       render :json => "Password has been reset".to_json, status: :ok
    else
      render :json => "Please try again ".to_json, status: :failed
    end
   end

   def password_params
    params.permit(
      :password,
      :password_confirmation, 
      
    )
  end 
   
end 