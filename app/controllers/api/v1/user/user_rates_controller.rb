module Api::V1::User
    class Api::V1::User::UserRatesController < ApiController


        def create
            @rated_user = User.find(params[:user_id])
            if @rated_user.id == current_user.id 
                render json: {status: 'FAIL', message: 'You are not allowed to rate your self!'},status: :ok
            else
                
               @user_rate = UserRate.where(user_id: @rated_user.id, rated_by: @current_user.id)
                 puts "user rate =",@user_rate
               if @user_rate.any?
                 if @user_rate.update(rate: params[:rate])
                    @rated_user.rate = @rated_user.user_rates.average(:rate)
                    if @rated_user.save
                        render json: {status: 'SUCCESS', message: @rated_user.name+' has been rated'},status: :ok
                    else
                        render json: {status: 'FAIL', message: 'Couldn\'t rate '+@rated_user.name},status: :ok
                    end
                 end
               else
                    @user_rate = @rated_user.user_rates.new( user_id: @rated_user.id, rated_by: @current_user.id, rate: params[:rate])
                    if @user_rate.save
                        @rated_user.rate = @rated_user.user_rates.average(:rate)
                        @rated_user.save
                        render json: {status: 'SUCCESS', message: @rated_user.name+' has been rated'},status: :ok
                    else
                        render json: {status: 'FAIL', message: 'Couldn\'t rate '+@rated_user.name},status: :ok
                    end
              end
           
            end

        end




    end
end
