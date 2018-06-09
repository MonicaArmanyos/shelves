class ApplicationController < ActionController::Base
    # include ActionController::Serialization  
    # protect_from_forgery :with => :exception
    def initialize()
        @serverkey  = "key=AAAAq-c6jdw:APA91bGwWnR9kGSuysCBBj_t0Il2Ka8V6OfnRL3wa7iM8OfoS6ACFKwWdnnre03fbvVikSh-U0AE60pT0wckepDIvzZZc_5owF9ZUarxfJP-0jw9p2eVUzMvfuSxFX9D6G_IsR8svcTu"
    end

    def send_notification(user_notification_tokens,title ,body , click_action)
        user_notification_tokens.each do |user_notification_token|
            JSON.load `curl https://fcm.googleapis.com/fcm/send \
        -H "Content-Type: application/json" \
        -H 'Authorization: #{@serverkey} ' \
        -d '{ "notification": {"title": "#{title}", "body": "#{body}", "click_action" : "#{click_action}"}, "to" : "#{user_notification_token.token}" }'`
        end
        
    end

end
