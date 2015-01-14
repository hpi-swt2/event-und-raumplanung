class PermissionsController < ApplicationController
  
  before_action :authenticate_user!
  before_action :authorize_admin

  def index    
    @users = User.all
    @groups = Group.all
    @categories = Permission.categories.keys
  end

  def submit
    if params[:type] == 'entity'
      @permitted_entity = determine_permitted_entity(params[:user])
      Permission.categories.keys.each do |category|
        if permission_params[category] == "1"
          @permitted_entity.permit(category)
        else
          @permitted_entity.unpermit(category)
        end
      end
      name = @permitted_entity.username if @permitted_entity.is_a?(User)
      name = @permitted_entity.name if @permitted_entity.is_a?(Group)
      respond_to do |format|
        format.json { render :json => '"' + I18n.t('permissions.updated_entity', entity: name) + '"', :status => :ok }
      end
    elsif params[:type] == 'permission'
      entities = User.all + Group.all
      entities.each do |entity|
        form_name = 'User:' + entity.id.to_s if entity.is_a?(User)
        form_name = 'Group:' + entity.id.to_s if entity.is_a?(Group)
        if params[form_name] == "1"
          entity.permit(params[:permission])
        else
          entity.unpermit(params[:permission])
        end
      end
      respond_to do |format|
        format.json { render :json => '"' + I18n.t('permissions.updated_permission', permission: I18n.t('permissions.' + params[:permission])) + '"', :status => :ok }
      end
    end
  end

  def determine_permitted_entity(entity_string)
    permitted_entity_id = entity_string.split(":")[1].to_i
    if entity_string.split(":")[0]==("User")     
       return User.find(permitted_entity_id)
    elsif entity_string.split(":")[0]==("Group")
       return Group.find(permitted_entity_id)
    end
  end

  def permitted_entities
    @permission = params[:permission]
    @permitted_entities = User.all + Group.all
    render :partial => "permitted_entities"
  end

  def user_permissions
    @permitted_entity = determine_permitted_entity(params[:user])
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
