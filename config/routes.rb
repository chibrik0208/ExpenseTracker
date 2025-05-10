Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  resources :expenses
  resources :users, only:[ :show, :edit, :update, :destroy ]
  get "/signup", to: "registrations#new", as: "signup" # это создает доп хелперы которые позволяют делать signup_path
  post "/singup", to: "registrations#create", as: "registrations" # это работает как new create одна создает запрос другая рендерит форму

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout

  root "expenses#index"
end
