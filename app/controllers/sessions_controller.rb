class SessionsController < Devise::SessionsController
  before_action :check_openid_provider, only: :create

  def new
    # Needed as attribute for admin password input
    if params.include?("admin")
      @admin = true
    else
      @admin = false
    end

    super 
  end

  def create
    # The create methode is called every time a user needs to be created with Open ID
      # First time: When the submit button of the session form is clicked
      # Second time: When the response from OpenID must be handled
    # First: We need an OpenID independent admin user
    # Second: We can not rely on an email given by OpenID 

    adminConf = Rails.application.config.login["admin"]

    # Check if admin username was entered in the session form
    if params.include?("user") and params["user"]["username"] == adminConf["username"]
      flash[:notice] = t('devise.sessions.admin_password')
      redirect_to(new_user_session_path(:admin => ""))
    # Check the enter admin password in the session form
    elsif params.include?("user") and params["user"].include?("encrypted_password")
      # Check correctness of the admin password
      if(params["user"]["encrypted_password"] == adminConf["password"])
        # Check if admin user is already existing
        if User.all.find_by_identity_url(adminConf["username"])
          @user = User.all.find_by_identity_url(adminConf["username"])
          sign_in @user
        else
          @user = User.build_from_identity_url(adminConf["username"])
          @user.username = adminConf["username"]
          @user.save
          sign_in @user
        end

        # Log in admin user and redirect to root
        flash[:notice] = t('devise.sessions.signed_in')
        redirect_to root_path
      else
        # Admin log in failed, redirect to log in
        flash[:error] = t('devise.failure.invalid')
        redirect_to root_path
      end
    # Proceed with normal Open ID log in 
    else
      # This token is set by devise-openidauthenticable when the session form is submitted
      # The status shall only be set by a submitted form
      if(params["authenticity_token"] != nil)
        session[:userStatus] = params[:status]
      end

      # The status is required for the email creation
      if(params["authenticity_token"] != nil and params[:status] == nil)
        flash[:error] = t('devise.sessions.status_missing')
        redirect_to root_path
      else
        # Devise specfic code (just take a look at the gems create method)
        self.resource = warden.authenticate!(auth_options)
        set_flash_message(:notice, :signed_in) if is_flashing_format?
        sign_in(resource_name, resource)
        yield resource if block_given?

        # Custom email, username and status creation
        @user.email = build_email_from_identity_url(params[:user][:username], session[:userStatus])

        if(@user.status != nil and @user.status != session[:userStatus])
          flash[:alert] = t('devise.sessions.status_changed')
        end

        @user.status = session[:userStatus]
        @user.username = params[:user][:username]
        @user.save

        # Clear the session variable
        session[:userStatus] = nil

        respond_with resource, location: after_sign_in_path_for(resource)
      end
    end
  end

  def build_email_from_identity_url(username, status)
    # Create the user email from given name and status
    if(status == "student")
      username + "@student.hpi.de"
    elsif(status == "staff")
      username + "@hpi.de"
    end
  end

  def check_openid_provider
    #if not params["user"]["identity_url"].start_with?("https://openid.hpi.uni-potsdam.de/user/")
    ##  redirect_to new_user_session_path, alert: "You can only login with a valid HPI OpenID!"
    ##end
  end
end
