class Api::V1::Notification::NotificationMessagesController < ApplicationController
     
    def get_user_notifications
        if  NotificationMessage.exists?(:receiver_user => params[:id])
            @notification_messages= NotificationMessage.where(:receiver_user => params[:id]).where(:created_at => Time.now.beginning_of_month..Time.now.end_of_month)
            render :json => @notification_messages, each_serializer: NotificationMessageSerializer
            #render json: {status: 'SUCCESS', message: 'Loaded notification_messages successfully', notification_messages:@notification_messages},status: :ok
        else
            render json: {status: 'FAIL', message: 'No Notification messages For that user'},status: :ok
        end
    end
end
