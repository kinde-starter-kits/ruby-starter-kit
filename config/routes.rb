Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "hello#index"

  get "callback" => "auth#callback"
  get "auth" => "auth#auth"
  get "logout" => "auth#logout"
  get "logout_callback" => "auth#logout_callback"
end
