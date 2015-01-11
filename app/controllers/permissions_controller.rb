class PermissionsController < ApplicationController
  
  before_action :authenticate_user!
  before_action :authorize_admin

  def index    
    @users = User.all
    @groups = Group.all   
  end

  def submit
    determine_permitted_entity
    Permission.categories.keys.each do |category|
      if permission_params[category] == "1"
        @permitted_entity.permit(category)
      else
        @permitted_entity.unpermit(category)
      end
    end
    redirect_to permissions_path
  end

  def determine_permitted_entity
    permitted_entity_id = params[:user].split(":")[1].to_i
    if params[:user].split(":")[0]==("User")     
       @permitted_entity = User.find(permitted_entity_id)
    elsif params[:user].split(":")[0]==("Group")
       @permitted_entity = Group.find(permitted_entity_id)
    end
  end

  def user_permissions
    determine_permitted_entity
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
