Rails.application.routes.draw do
  require 'sidekiq/web'
  # Sidekeq web interface route
  mount Sidekiq::Web => '/sidekiq'
  devise_for :users
  resources :bills do
    collection do
      get 'filter', to: 'bills#filter', as: 'filter'
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get '/generate_pdf', to: 'pdf_examples#generate_pdf'
  # Defines the root path route ("/")
  root "bills#index"
end
