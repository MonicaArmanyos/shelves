class Api::V1::Notification::NotificationMessagesController < ApplicationController
     
    def get_user_notifications
        if  NotificationMessage.exists?(:receiver_user => params[:id])
            @notification_messages= NotificationMessage.where(:receiver_user => params[:id]).where(:created_at => Time.now.beginning_of_month..Time.now.end_of_month)
            render :json => @notification_messages, each_serializer: NotificationMessageSerializer
        else
            render json: {status: 'FAIL', message: 'No Notification messages For this user'},status: :ok
        end
    end

    def update_seen_notification
        if  NotificationMessage.exists?(:receiver_user => params[:id])
            @notification_message = NotificationMessage.find(params[:id])
            @notification_message.update(:is_seen => 1)
            render json: {status: 'SUCCESS', message: 'Notification is seen by user'},status: :ok
        else
            render json: {status: 'FAIL', message: 'No Notification messages For this user'},status: :ok
        end  

    end

end
