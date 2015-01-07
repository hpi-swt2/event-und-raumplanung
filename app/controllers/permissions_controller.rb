class PermissionsController < ApplicationController
  
  before_action :authenticate_user!

  def index
    @categories = Permission.categories.keys
    @users = User.all
  end

  def submit
    user = User.find(params[:user].to_i)
    Permission.categories.keys.each do |category|
      if params[category] == "1"
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
    render :partial => "categories"
  end

end
