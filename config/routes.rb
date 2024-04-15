Rails.application.routes.draw do
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
