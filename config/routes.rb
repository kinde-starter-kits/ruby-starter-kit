Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "hello#index"

  get "mgmt" => "hello#mgmt_index"
  post "mgmt_create_organization" => "hello#create_organization"
  post "mgmt_create_user" => "hello#create_user"

  mount KindeSdk::Engine, at: "/kinde_sdk"
end
