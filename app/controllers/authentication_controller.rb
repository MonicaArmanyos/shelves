class AuthenticationController < ApiController
    skip_before_action :authenticate_request, only: :authenticate

    def authenticate
      command = AuthenticateUser.call(params[:email], params[:password])
   
      if command.success?
        @user= User.find_by_email(params[:email])
        if  @user.email_confirmed
          render json: { auth_token: command.result }, status: :created
        else 
          render json: :inactive
        end
      else
        render json: { error: command.errors }, status: :unauthorized
      end
    end
end
