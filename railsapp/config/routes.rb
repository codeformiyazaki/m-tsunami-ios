Rails.application.routes.draw do
  root 'pages#root'
  resources :apn_tokens
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
