Rails.application.routes.draw do
  get 'password_resets/new'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace 'api' do
    namespace 'v1' do

      namespace 'book' do     
        resources :books, except:[:new, :edit] do
          resources :rates
            
            #/api/v1/book/books/route_name
            collection do
              get :latest_books
              get :recommended_books
             
            end

            #/api/v1/book/books/:id/route_name
            member do
              get 'exchange', to: 'books#exchange'
              put 'update_bid', to: 'books#update_bid'
            end
            resources :orders do
              #/api/v1/book/books/:id/orders
              member do
               put :confirm_order
               delete :dismiss_order
              end
            end  
            resources :comments do
              resources :replies
            end  
             #route of :  request_exchange
            # /api/v1/book/books/:id/exchange_request
            member do
              get 'myorders', to: 'orders#showOrders' 
              post 'exchange_request', to: 'orders#exchange_request'
              post 'confirm_exchange', to: 'orders#confirm_exchange'
              delete 'dismiss_exchange', to: 'orders#dismiss_exchange'

            end
          end
        end

        namespace 'category' do
          resources :categories do
             # /api/v1/category/categories/:id/get_books_for_category
             member do
              get 'get_books_for_category', to: 'categories#get_books_for_category'
            end
          end

        end
       

        namespace 'user' do 
          resources :password_resets, only: [:create, :update]
          resources :users,  except: [:index, :destroy, :create, :new, :edit] do
            resources :user_rates
            collection do
              post 'login', to: 'authentication#authenticate', :as => "login"
                post 'signup', to: 'users#create', :as => "signup"
                get '', to: 'users#show'
                get 'get_all_book_stores' => 'users#get_all_book_stores'
                get 'cites', to: 'users#getCities', :as => "city"
              end
              #/users/:confirm_tocken/confirm_email
              member do
                get '/confirm_email'=> 'users#confirm_email' 
                get 'get_user_books'=> 'users#get_user_books'
              end

            end
          end

            namespace 'notification' do 
              resources :notification_tokens
              resources :notification_messages do
 
                #/api/v1/notification/notification_messages/get_user_notifications
                collection do
                  get 'get_user_notifications', to: 'notification_messages#get_user_notifications'
                  put 'update_seen_notification', to: 'notification_messages#update_seen_notification'
                  get 'get_no_unseen_notification_messages', to: 'notification_messages#get_no_unseen_notification_messages'
                end
              end
            end


            
          end 
        end

       
end
