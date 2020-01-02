Rails.application.routes.draw do
  resources :devices
  resources :quakes
  resources :apn_tokens

  root 'pages#root'
  get '/test-notify', to: 'apn_tokens#test_notify'
  get '/test-quake', to: 'quakes#test_quake'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
