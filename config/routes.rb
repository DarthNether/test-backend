Rails.application.routes.draw do
  root 'tareas#index'

  resources :tareas
  get '/export' => 'tareas#export_api'
end
