class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :setup_filterrific

  protected
  def authenticate_user!
    if user_signed_in?
      super
    else
      store_location_for(:user, request.env['PATH_INFO'])
      redirect_to new_user_session_path
    end
  end

  def after_sign_in_path_for(resource)
    stored_location_for(:user)
  end

  def setup_filterrific
    @filterrific = Filterrific.new(
    Event,
    params[:filterrific] || session[:filterrific_events])
    @filterrific.select_options =   {
      sorted_by: Event.options_for_sorted_by
    }
    @filterrific.own = if @filterrific.own == 1
        current_user_id
      else
        nil
      end
    @filterrific.room_ids = Room.all.map(&:id) if @filterrific.room_ids && @filterrific.room_ids.size <=1

    session[:filterrific_events] = @filterrific.to_hash
      
  end

  # Link to root if a access denied exception by cancancan occurs
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
end
