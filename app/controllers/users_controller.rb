class UsersController < ApiController
    skip_before_action :authenticate_request, only: [:create, :confirm_email]
    # POST /signup
    # return authenticated token upon signup
    def create
      @user = User.create!(user_params)
      @user.profile_picture = "/assets/images/default_profile.jpg"
      if @user.save
        UserMailer.registration_confirmation(@user).deliver
      auth_token = AuthenticateUser.new(@user.email, @user.password).call
      response = { message: Message.account_created, auth_token: auth_token }
      render json: response, status: :created
     else
        head(:unprocessable_entity)
      end
    end
  

    def confirm_email
        user=User.find_by_confirm_token(params[:id])
        if user
          user.email_activate
          render :json => "Your account has now been confirmed.You can login now !".to_json, status: :ok
        else 
          render :json => "Your account has now been confirmed.You can login now !".to_json, status: :notfound
       end
      
     end

    private
  
    def user_params
      params.permit(
        :name,
        :email,
        :password,
        :password_confirmation, 
        :role
      )
  end
end
