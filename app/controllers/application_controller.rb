class ApplicationController < ActionController::Base
    # include ActionController::Serialization  
    # protect_from_forgery :with => :exception

    #### server Key configuration of firebase project ####
    def initialize()
        @serverkey  = "key=AAAAq-c6jdw:APA91bGwWnR9kGSuysCBBj_t0Il2Ka8V6OfnRL3wa7iM8OfoS6ACFKwWdnnre03fbvVikSh-U0AE60pT0wckepDIvzZZc_5owF9ZUarxfJP-0jw9p2eVUzMvfuSxFX9D6G_IsR8svcTu"
        @serverurl = "http://localhost:3000"
    end

    #### send notification function ####
    def send_notification(user_notification_tokens ,body ,icon, click_action)
        user_notification_tokens.each do |user_notification_token|
            JSON.load `curl https://fcm.googleapis.com/fcm/send \
        -H "Content-Type: application/json" \
        -H 'Authorization: #{@serverkey} ' \
        -d '{ "notification": {"title": "Shelves", "body": "#{body}", "icon": "#{icon}" "click_action" : "#{click_action}"}, "to" : "#{user_notification_token.token}" }'`
        end
        
    end

end
