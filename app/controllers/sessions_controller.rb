class SessionsController < Devise::SessionsController

  def new
    # Needed as attribute for admin password input
    @admin = params.include?("admin")
    super 
  end

  def create
    # The create methode is called every time a user needs to be created with Open ID
      # First time: When the submit button of the session form is clicked
      # Second time: When the response from OpenID must be handled
    # First: We need an OpenID independent admin user
    # Second: We can not rely on an email given by OpenID 

    # Devise specfic code (just take a look at the gems create method)
    provider_response = env[Rack::OpenID::RESPONSE]
    identity_url_temp = ""

    if provider_response.kind_of? OpenID::Consumer::SuccessResponse
      identity_url_temp = provider_response.endpoint.claimed_id
      username_temp = identity_url_temp.split('/').last
      session[:username] = username_temp
    end

    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)
    yield resource if block_given?

    if provider_response.kind_of? OpenID::Consumer::SuccessResponse
      # Custom email and username
      if @user.username == "" &&  @user.identity_url == nil
        @user.identity_url = identity_url_temp
        @user.email = @user.username + Time.now.to_s
        @user.save
      end

      if @user.firstlogin
        redirect_to "/profile"
      else
        respond_with resource, location: after_sign_in_path_for(resource)
      end

      # Clear the session variable
      session[:username] = nil
    end
  end

  def show_admin_login
    render :admin
  end

  def authenticate_admin
    admin_conf = Rails.application.config.login["admin"]
    
    email = params["email"]
    password = params["encrypted_password"]
    if (email == admin_conf["email"] && password == admin_conf["password"])
      admin_user = User.find_by_email(admin_conf["email"])

      if admin_user.nil?
        admin_user = User.create(:username => admin_conf["username"], :email => admin_conf["email"])
      end

      sign_in admin_user
      redirect_to root_path
    else
      flash[:error] = t('devise.failure.invalid')
      redirect_to admin_path
    end
  end
end
