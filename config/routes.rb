Rails.application.routes.draw do
  resources :tournaments
  post '/parse', to: 'tournaments#parse_events', as: 'button'
  get '/', to: 'tournaments#destroy_all', as: 'destroy_all'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'tournaments#index'

end
