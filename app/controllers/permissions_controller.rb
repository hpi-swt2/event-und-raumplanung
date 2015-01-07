class PermissionsController < ApplicationController
  
  before_action :authenticate_user!
  before_action :authorize_admin

  def index    
    @users = User.all
  end

  def submit
    user = User.find(permission_params[:user].to_i)
    Permission.categories.keys.each do |category|
      if permission_params[category] == "1"
        user.permit(category)
      else
        user.unpermit(category)
      end
    end
    redirect_to permissions_path
  end

  def user_permissions
    @user = User.find(params[:user_id])
    @categories = Permission.categories.keys
    render :partial => "user_permissions"
  end

  def authorize_admin
    authorize! :manage, Permission
  end

  def permission_params
    params.permit(:user)
    Permission.categories.keys.each do |category|
      params.permit(category)
    end
    return params
  end  

end
