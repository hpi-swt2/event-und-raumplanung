Rails.application.routes.draw do

  get '/change_locale/:locale' => 'locale#change_locale', as: "change_locale"

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
      get 'autocomplete', :action => 'autocomplete', :as => 'autocomplete'
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

 # post 'events/:id/approve' => 'events#approve', as: "approve_event"
 # post 'events/:id/decline' => 'events#decline', as: "decline_event"

  match "events/:id/approve" => "events#approve", as: :approve_event, via: [:get, :post]
  match "events/:id/decline" => "events#decline", as: :decline_event, via: [:get, :post]

  get 'events_between' => 'dashboard#events_between'
  get 'events/:id/declineconflicting' => 'events#declineconflicting', as: "decline_conflicting"
  get 'events/:id/decline_all' => 'events#decline_all', as: "decline_all"
  get 'events/:id/decline_pending' => 'events#decline_pending', as: "decline_pending"

  # post 'events/:id/approve' => 'events#approve', as: "approve_event"
  # get 'events/:id/decline' => 'events#decline', as: "decline_event"
  # get 'events/:id/approve_event_suggestion' => 'events#approve_event_suggestion', as: "approve_event_suggestion"
  # get 'events/:id/decline_event_suggestion' => 'events#decline_event_suggestion', as: "decline_event_suggestion"

  get 'rooms/list'
  post 'rooms/list', as: 'roomlist'
  get 'rooms/:id/details' => 'rooms#details'
  get 'rooms/printoverview', as: 'print'
  get 'rooms/:id/print' => 'rooms#print'
  get 'rooms/print/' => 'rooms#print_rooms'
  post 'rooms/list'
  post 'rooms/getValidRooms' => 'rooms#get_valid_rooms', as: "valid_rooms"
  post 'rooms/:id' => 'rooms#details'
  get 'event_occurrence' => 'event_occurrence#show', as: "show_occurrence"
  delete 'event_occurrence' => 'event_occurrence#destroy', as: "delete_occurrence"

  post 'tasks/upload_file' => 'tasks#upload_file'

  devise_scope :user do
    get 'admin', controller: 'sessions', action: 'show_admin_login'
    post 'authenticate_admin', controller: 'sessions', action: 'authenticate_admin', as: 'authenticate_admin'
  end

  # post 'authenticate_admin', controller: 'sessions', action: 'authenticate_admin'

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
      post :create_event_suggestion
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
  resources :users, only: [:edit, :show, :update]

  resources :event_templates, :path => "templates"
  resources :event_templates do
    get :reset_filterrific, on: :collection
  end

  get 'ical/:icaltoken' => 'ical#get'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  # You can have the root of your site routed with "root"
  root 'dashboard#index'

  get 'templates/:id/new_event' => 'event_templates#new_event', as: :new_event_from_template
  get 'events/:id/new_event_template' => 'events#new_event_template', as: :new_event_template_from_event
  get 'events/:id/new_event_suggestion' => 'events#new_event_suggestion', as: :new_event_suggestion_from_event


  get 'events/:id/index_toggle_favorite' => 'events#index_toggle_favorite', as: :index_toggle_favorite_from_event
  get 'events/:id/show_toggle_favorite' => 'events#show_toggle_favorite', as: :show_toggle_favorite_from_event

  get 'rooms/:id/events' => 'rooms#list_events', as: :room_events

end
