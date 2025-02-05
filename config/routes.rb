Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  get "ceps", to: "ceps#index"

  root "pages#welcome"
  post '/change_language', to: 'language#change'
end
