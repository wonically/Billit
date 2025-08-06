Rails.application.routes.draw do
  namespace :api do
    get "invoices/index"
    get "invoices/show"
    get "invoices/create"
    get "invoices/update"
    get "invoices/destroy"
    get "clients/index"
  end
# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api do
    devise_for :users,
      controllers: {
        registrations: 'api/users/registrations',
        sessions: 'api/users/sessions'
      }
    resources :clients, only: [:index, :show, :create, :update, :destroy]
    resources :invoices
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
