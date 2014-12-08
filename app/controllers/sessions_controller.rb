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
    domains = Rails.application.config.login["domains"]

    # Check if admin username was entered in the session form
    if params.include?("user") and params["user"]["email"] == adminConf["email"]
      flash[:notice] = t('devise.sessions.admin_password')
      redirect_to(new_user_session_path(:admin => ""))
    # Check the enter admin password in the session form

    elsif params.include?("user") and params["user"].include?("encrypted_password")
      # Check correctness of the admin password
      if(params["user"]["encrypted_password"] == adminConf["password"])
        # Check if admin user is already existing
        if User.all.find_by_identity_url(adminConf["email"])
          @user = User.all.find_by_identity_url(adminConf["email"])
          sign_in @user
        else
          @user = User.build_from_identity_url(adminConf["email"])
          @user.username = adminConf["username"]
          @user.email = adminConf["email"];
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
      if(params["authenticity_token"] != nil)
        session[:email] = params[:user][:email] 
      end

      # check mail-domain for a valid HPI domain
      if not domains.include?(session[:email].split('@').last)
          flash[:error] = t('devise.sessions.wrong_domain')
          flash[:notice] = "";
          redirect_to root_path
      else

        # Devise specfic code (just take a look at the gems create method)
        self.resource = warden.authenticate!(auth_options)
        set_flash_message(:notice, :signed_in) if is_flashing_format?
        sign_in(resource_name, resource)
        yield resource if block_given?
        #check if the user has registered with a different email in the past
        if(@user.email != nil and @user.email != session[:email] and @user.email != '')
          flash[:error] = t('devise.sessions.email_invalid') 
          flash[:notice] = "";
          sign_out @user
          redirect_to root_path
        else

          # Custom email, username and status creation
          @user.email = params["user"]["email"];
          @user.username = build_name_from_email(params[:user][:email]);
          if (@user.username != build_name_from_identity_url(current_user.identity_url))
            flash[:error] = t('devise.sessions.wrong_username')
            flash[:notice] = "";
            sign_out @user
            redirect_to root_path
          end
          

          @user.save

          # Clear the session variable
          

          respond_with resource, location: after_sign_in_path_for(resource)
        end
        session[:email] = nil
      end
    end
  end

  def build_name_from_identity_url(identity_url)
    identity_url.split('/').last
  end


  def build_name_from_email(email)
    # Create the user email from given name and status
    email.split('@').first
  end


  def check_openid_provider
    #if not params["user"]["identity_url"].start_with?("https://openid.hpi.uni-potsdam.de/user/")
    ##  redirect_to new_user_session_path, alert: "You can only login with a valid HPI OpenID!"
    ##end
  end
end
