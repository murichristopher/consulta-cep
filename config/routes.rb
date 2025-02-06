Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  get "ceps", to: "ceps#index"

  root "ceps#index"
  post "/change_language", to: "language#change"
end
