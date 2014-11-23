class SessionsController < Devise::SessionsController
  before_action :check_openid_provider, only: :create

  def check_openid_provider
    #if not params["user"]["identity_url"].start_with?("https://openid.hpi.uni-potsdam.de/user/")
    ##  redirect_to new_user_session_path, alert: "You can only login with a valid HPI OpenID!"
    ##end
  end
end
