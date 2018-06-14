class Api::V1::Notification::NotificationMessagesController < ApplicationController
    
    #### get all notification messages for current user
    def get_user_notifications
        if  NotificationMessage.exists?(:receiver_user => params[:id])
            @notification_messages= NotificationMessage.where(:receiver_user => params[:id]).where(:created_at => Time.now.beginning_of_month..Time.now.end_of_month)
            render :json => @notification_messages, each_serializer: NotificationMessageSerializer
        else
            render json: {status: 'FAIL', message: 'No Notification messages For this user'},status: :ok
        end
    end

    #### update notification message to be seen
    def update_seen_notification
        if  NotificationMessage.exists?(:id => params[:id])
            @notification_message = NotificationMessage.find(params[:id])
            @notification_message.update(:is_seen => 1)
            render json: {status: 'SUCCESS', message: 'Notification is seen by user'},status: :ok
        else
            render json: {status: 'FAIL', message: 'No Notification messages for this id'},status: :ok
        end  

    end

    #### get all unseen notification messages for current_user 
    def get_no_unseen_notification_messages
        if  NotificationMessage.exists?(:receiver_user => params[:id])
            @notification_message = NotificationMessage.find(params[:id]).where(:is_seen => 0)
            @unseen_notification_messages =  @notification_message.count
            render json: {status: 'SUCCESS', message: 'Notification is seen by user', no_unseen_notification_messages: @unseen_notification_messages},status: :ok
        else
            render json: {status: 'FAIL', message: 'No Notification messages For this user'},status: :ok
        end  
    end

   
end
