Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace 'api' do
    resources :categories
    resources :books do
      #/api/books/route_name
      collection do
        get :latest_books
        get :recommended_books
      end
      #/api/books/:id/route_name
      member do
        
      end
    end
   end 
end
