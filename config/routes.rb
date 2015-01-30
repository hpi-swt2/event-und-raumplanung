Rails.application.routes.draw do

  resources :uploads, :only => [:new, :create, :destroy]

  resources :permissions, :only => [:index] do
    collection do
      post :submit
      post 'permissions_for_entity', action: 'checkboxes_by_entity'
      post 'entities_for_permission', action: 'checkboxes_by_permission'
    end
  end

  resources :event_suggestions

  resources :groups do
    member do
      get 'manage_rooms'
      get 'assign_room/:room_id', :action => 'assign_room', :as => 'assign_room'
      get 'unassign_room/:room_id', :action => 'unassign_room', :as => 'unassign_room'
      patch 'assign_rooms'
      patch 'assign_user', :action => 'assign_user', :as => 'assign_user'
      get 'unassign_user/:user_id', :action => 'unassign_user', :as => 'unassign_user'
      get 'promote_user/:user_id', :action => 'promote_user', :as => 'promote_user'
      get 'degrade_user/:user_id', :action => 'degrade_user', :as => 'degrade_user'
    end
  end

  get 'profile/index' => 'profile#index'
  post 'profile_update_profile' => 'profile#update_profile', as: "update_profile"

  get 'events_approval/index'
  get 'events_approval/' => 'events_approval#index'

  post 'events_create_comment' => 'events#create_comment', as: "create_comment"
  post 'events_delete_comment' => 'events#delete_comment', as: "delete_comment"
  post 'events/:id/approve' => 'events#approve', as: "approve_event"
  post 'events/:id/decline' => 'events#decline', as: "decline_event"


  # post 'events/:id/approve' => 'events#approve', as: "approve_event"
  # get 'events/:id/decline' => 'events#decline', as: "decline_event"
  # get 'events/:id/approve_event_suggestion' => 'events#approve_event_suggestion', as: "approve_event_suggestion"
  # get 'events/:id/decline_event_suggestion' => 'events#decline_event_suggestion', as: "decline_event_suggestion"

  get 'rooms/list'
  post 'rooms/list', as: 'roomlist'
  get 'rooms/:id/details' => 'rooms#details'
  get 'rooms/printoverview'
  get 'rooms/:id/print' => 'rooms#print'
  post 'rooms/list'
  post 'rooms/getValidRooms' => 'rooms#getValidRooms', as: "valid_rooms"
  post 'rooms/:id' => 'rooms#details'
  get 'event_occurrence' => 'event_occurrence#show', as: "show_occurrence"

  post 'tasks/upload_file' => 'tasks#upload_file'

  devise_for :users, :controllers => {:sessions => "sessions"}

  get "identities/autocomplete" => "identities#autocomplete"

  resources :attachments

  resources :room_properties

  resources :rooms do
    get :reset_filterrific, on: :collection
  end

  resources :tasks do
    post :update_task_order, on: :collection
  end

  get 'tasks/:id/accept' => 'tasks#accept', :as => :accept_task
  get 'tasks/:id/decline' => 'tasks#decline', :as => :decline_task
  put 'tasks/:id/set_done' => 'tasks#set_done', :as => :set_task_done

  resources :bookings

  resources :equipment

  get 'fetch_event' => 'rooms#fetch_event', as: :fetch_event

  patch 'checkVacancy' => 'events#check_vacancy', as: :check_event_vacancy

  resources :events do
    collection do
      get :create_event_suggestion
      patch :create_event_suggestion
      post :creat_event_suggestion
      get :reset_filterrific
    end

    member do
      post :approve
      post :decline
      get :decline
      get :approve_event_suggestion
      get :decline_event_suggestion
      get :new_event_template
      get :new_event_suggestion
      get :index_toggle_favorite
      get :show_toggle_favorite
    end
  end

  resources :maps
  resources :profile

  resources :event_templates, :path => "templates"
  resources :event_templates do
    get :reset_filterrific, on: :collection
  end

  get 'ical/event/:id/' => 'ical#show_event', :as => :ical_event
  get 'ical/' => 'ical#show_my_events'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  # You can have the root of your site routed with "root"
  root 'dashboard#index'

  get 'templates/:id/new_event' => 'event_templates#new_event', as: :new_event_from_template
  get 'events/:id/new_event_template' => 'events#new_event_template', as: :new_event_template_from_event
  get 'events/:id/new_event_suggestion' => 'events#new_event_suggestion', as: :new_event_suggestion_from_event


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
