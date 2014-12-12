Rails.application.routes.draw do

  resources :groups do
    member do
      get 'manage_rooms'
      get 'assign_room/:room_id', :action => 'assign_room', :as => 'assign_room'
      get 'unassign_room/:room_id', :action => 'unassign_room', :as => 'unassign_room'
      get 'assign_user/:user_id', :action => 'assign_user', :as => 'assign_user'
      get 'unassign_user/:user_id', :action => 'unassign_user', :as => 'unassign_user'
    end
  end

  get 'events_approval/index'
  get 'events_approval/' => 'events_approval#index'
  post 'events/:id/approve' => 'events#approve', as: "approve_event"
  post 'events/:id/decline' => 'events#decline', as: "decline_event"
  get 'rooms/list'
  get 'rooms/:id/details' => 'rooms#details'
  post 'rooms/list'
  post 'rooms/:id' => 'rooms#details'

  devise_for :users, :controllers => {:sessions => "sessions"}

  resources :attachments

  resources :room_properties

  resources :rooms

  resources :tasks do
    post :update_task_order, on: :collection
  end

  get 'tasks/:id/accept' => 'tasks#accept', :as => :accept_task
  get 'tasks/:id/decline' => 'tasks#decline', :as => :decline_task

  resources :bookings

  resources :equipment

  resources :events do
    get :reset_filterrific, on: :collection
  end

  resources :maps

  resources :event_templates, :path => "templates"
  resources :event_templates do
    get :reset_filterrific, on: :collection
  end



  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  # You can have the root of your site routed with "root"
  root 'dashboard#index'

  get 'templates/:id/new_event' => 'event_templates#new_event', as: :new_event_from_template
  get 'events/:id/new_event_template' => 'events#new_event_template', as: :new_event_template_from_event

  get 'events/:id/index_toggle_favorite' => 'events#index_toggle_favorite', as: :index_toggle_favorite_from_event
  get 'events/:id/show_toggle_favorite' => 'events#show_toggle_favorite', as: :show_toggle_favorite_from_event

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase  
  get 'rooms/:id/events' => 'rooms#list_events', as: :room_events

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
