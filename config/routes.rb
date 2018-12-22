Rails.application.routes.draw do
  get 'sessions/new'




  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "index#index"
  get '/signup', to: 'index#signup'



  post '/upload', to: 'drivers#upload'
  get '/show', to: 'drivers#show'
  get '/edit', to: 'drivers#edit'
  
  get '/to_take_order', to: 'drivers#to_take_order'
  get '/taken_order', to: 'drivers#taken_order'
  get '/finished_order', to: 'drivers#finished_order'
  

  post '/upload', to: "driver#upload"


  get '/login', to: "sessions#new"
  post '/login', to: 'sessions#create'
  delete  '/logout', to: 'sessions#destroy'
 
  get '/order' , to: 'students#new_order'
  post '/order', to: 'students#create_order'
  get '/orders', to: 'index#orders'
  
 
  patch '/order/:id/join', to: 'students#join_order'
  get '/order/:id/edit', to: 'students#edit_order'
  delete '/order/:id/delete', to: 'students#delete_order'
  
  get '/student/:id/orders', to: 'students#current_orders'
  get '/student/:id/accept_orders', to: 'students#accept_orders'
  get '/student/:id/history', to: 'students#history'
  patch '/order/:id/update', to: 'students#update_order'
  
  get '/order/:id/driver', to: 'students#driver_info'
  patch '/order/:id/quit', to: 'students#quit_order'
  patch '/order/:id/student_finish', to: 'students#finish_order'
  
  patch '/order/:id/take', to: 'drivers#take_order'
  patch '/order/:id/driver_finish', to: 'drivers#finish_order'
  get '/driver/:id/accept_orders', to: 'drivers#accept_orders'
  get '/driver/:id/finished_orders', to: 'drivers#finished_orders'
  get '/driver/:id/history_orders', to: 'drivers#history_orders'
  
  post '/student/:id/head', to: 'students#update_head'
  post '/student/:id/idcard', to: 'students#update_idcard'
  
  get '/managers/driver_info'
  get '/managers/students_info'
  get '/managers/orders_info'

  resources :drivers
  resources :students
  resources :managers
  
end 
