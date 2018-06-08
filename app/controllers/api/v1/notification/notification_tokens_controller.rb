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

        private
        #### Permitted book params ####
        def notification_token_params
            params.require(:notification_token).permit(:token, :user_id)
        end


    end
end
