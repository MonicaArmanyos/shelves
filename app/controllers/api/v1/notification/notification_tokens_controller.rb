module Api::V1::Notification
    class Api::V1::Notification::NotificationTokensController < ApplicationController
        
        #### Create notification_token ####
        def create
                @notification_token = NotificationToken.new(notification_token_params)
                if @notification_token.save
                    render json: {status: 'SUCCESS', message: 'token saved successfully ', notification_token:@notification_token},status: :ok
                else
                    render json: {status: 'FAIL', message: 'Couldn\'t save token in database'},status: :ok
                end
        end

        #### Update notification_token ####
        def update
            if  NotificationToken.exists?(:token => params[:id])
                @notification_token = NotificationToken.where(:token => params[:id])
                @notification_token.update(notification_token_params)
                render json: {status: 'SUCCESS', message: 'notification_token successfully updated', notification_token:@notification_token},status: :ok
            else
                render json: {status: 'FAIL', message: 'Couldn\'t update notification_token'},status: :ok
            end 
        end

        private
        
        #### Permitted notifcation_token params ####
        def notification_token_params
            params.require(:notification_token).permit(:token, :user_id)
        end


    end
end
