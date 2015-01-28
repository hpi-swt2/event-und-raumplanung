class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected
  def authenticate_user!
    if user_signed_in?
      if @current_user.email != nil
        super
      else
        if not params[:controller] == "profile"
          redirect_to "/profile"
        end
      end
    else
      store_location_for(:user, request.env['PATH_INFO'])
      redirect_to new_user_session_path
    end
  end

  def after_sign_in_path_for(resource)
    stored_location_for(:user)
  end

  # Link to root if a access denied exception by cancancan occurs
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
end