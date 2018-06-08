Rails.application.routes.draw do
  get 'password_resets/new'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users,  except: [:index, :destroy, :create, :new, :edit] do
    collection do
      post 'login', to: 'authentication#authenticate', :as => "login"
      post 'signup', to: 'users#create', :as => "signup"
      get '', to: 'users#show'
    end
    #/users/:confirm_tocken/confirm_email
    member do
    get '/confirm_email'=> 'users#confirm_email' 
    end
  end
  resources :password_resets, only: [:create, :update]
  namespace 'api' do
    resources :categories
    resources :books, except:[:new, :edit] do
      resources :rates
   
      #/api/books/route_name
      collection do
        get :latest_books
        get :recommended_books
      end
      #/api/books/:id/route_name
      member do
        get 'exchange', to: 'books#exchange'
      end
      resources :orders
    end
   end 
end
