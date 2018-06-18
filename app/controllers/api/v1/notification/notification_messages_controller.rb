class Api::V1::Notification::NotificationMessagesController < ApplicationController
    before_action :authenticate_request
    #### get all notification messages for current user
    def get_user_notifications
        
            if  NotificationMessage.exists?(:receiver_user => @current_user.id)
                 if (params[:status]).eql? nil
                    
                    @notification_messages= NotificationMessage.where(:receiver_user => @current_user.id).where(:created_at => Time.now.beginning_of_month..Time.now.end_of_month).order("created_at DESC")
                    
                elsif params[:status] == "navbar-notifications"
                     @notification_messages= NotificationMessage.where(:receiver_user => @current_user.id).where(:created_at => Time.now.beginning_of_month..Time.now.end_of_month).order("created_at DESC").limit(8)
                end
                if @notification_messages.count != 0
                    render :json => @notification_messages, each_serializer: NotificationMessageSerializer
                else
                    render json: {status: 'FAIL', message: 'No Notification messages For this user'},status: :ok
                end
            else
                render json: {status: 'FAIL', message: 'No Notification messages For this user'},status: :ok
            end

    end

    #### update notification message to be seen
    def update_seen_notification
        if  NotificationMessage.exists?(:receiver_user => @current_user.id)
            @notification_messages = NotificationMessage.where(:receiver_user => @current_user.id).where(:is_seen => 0)
            if @notification_messages.count != 0
                @notification_messages.each do |notification_message|
                    notification_message.update(:is_seen => 1)
                end
                render json: {status: 'SUCCESS', message: 'Notification is seen by user'},status: :ok
            else
                render json: {status: 'FAIL', message: 'No Notification messages for this id'},status: :ok
            end

        else
            render json: {status: 'FAIL', message: 'No Notification messages for this id'},status: :ok
        end  

    end

    #### get all unseen notification messages for current_user 
    def get_no_unseen_notification_messages
        if  NotificationMessage.exists?(:receiver_user => @current_user.id)
            @notification_message = NotificationMessage.where(:receiver_user => @current_user.id).where(:is_seen => 0)
            @unseen_notification_messages =  @notification_message.count
            if @unseen_notification_messages != 0
                render json: {status: 'SUCCESS', message: 'Notifications are seen by user', no_unseen_notification_messages: @unseen_notification_messages},status: :ok
            else
                render json: {status: 'FAIL', message: 'No Notification messages For this user'},status: :ok
            end

        else
            render json: {status: 'FAIL', message: 'No Notification messages For this user'},status: :ok
        end  
    end
    
    private
    #### Authentication of user ####
    def authenticate_request
        @current_user = AuthorizeApiRequest.call(request.headers).result
        render json: { error: 'Not Authorized' }, status: 401 unless @current_user
    end
   
end
