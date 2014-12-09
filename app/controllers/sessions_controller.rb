class SessionsController < Devise::SessionsController
  before_action :check_openid_provider, only: :create

  def new
  	if params.include?("admin")
  	  @admin = true
  	else
  	  @admin = false
  	end

    adminConf = Rails.application.config.admin["admin"]

    # Check if admin identity url was entered
  	if params.include?("user") and params["user"]["identity_url"] == adminConf["identity_url"]
  	  flash[:notice] = t('devise.sessions.admin_password')
  	  redirect_to(new_user_session_path(:admin => ""))
    # Check the enter admin password
  	elsif params.include?("user") and params["user"]["encrypted_password"] == adminConf["password"]
      # Check if admin user is already existing
  	  if User.all.find_by_identity_url(adminConf["identity_url"])
  	  	@user = User.all.find_by_identity_url(adminConf["identity_url"])
  	  	sign_in @user
  	  else
        @user = User.build_from_identity_url(adminConf["identity_url"])
  	  	@user.save
  	  	sign_in @user
  	  end

      # Log in admin user and redirect to root
      flash[:notice] = t('devise.sessions.signed_in')
  	  redirect_to root_path
    # Proceed with normal Open ID log in 
  	else
  	  super
  	end
  end

  def check_openid_provider
    #if not params["user"]["identity_url"].start_with?("https://openid.hpi.uni-potsdam.de/user/")
    ##  redirect_to new_user_session_path, alert: "You can only login with a valid HPI OpenID!"
    ##end
  end
end
