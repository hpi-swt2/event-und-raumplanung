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
      submit_entities
    elsif params[:type] == 'permission'
      submit_permissions
    end
  end

  def permit_per_room(entity, category)
    rooms_to_permit = []
    rooms_to_permit = params[:rooms][category] if params[:rooms][category].present?
    if rooms_to_permit.include?('all')
      entity.permit(category)
      rooms_to_permit = []
    else
      entity.unpermit(category)
    end
    Room.all.each do |room|
      if rooms_to_permit.include?(room.id.to_s)
        entity.permit(category, room)
      else
        entity.unpermit(category, room)
      end
    end
  end

  def submit_permissions
    entities = User.all + Group.all
    permission = params[:permission]
    entities.each do |entity|
      form_name = 'User:' + entity.id.to_s if entity.is_a?(User)
      form_name = 'Group:' + entity.id.to_s if entity.is_a?(Group)
      if params[form_name] == "1"
        if permission != 'approve_events'
          entity.permit(permission)
        else
          permit_per_room(entity, permission)
        end
      else
        entity.unpermit_all(params[:permission])
      end
    end
    respond_to do |format|
      data = {message: I18n.t('permissions.updated_permission', permission: I18n.t('permissions.' + params[:permission]))}
      format.json { render :json => data, :status => :ok }
    end
  end

  def submit_entities
    entity = determine_permitted_entity(params[:user])
    Permission.categories.keys.each do |category|
      if permission_params[category] == "1"
        if category != 'approve_events'
          entity.permit(category)
        else
          permit_per_room(entity, category)
        end
      else
        entity.unpermit_all(category)
      end
    end
    name = entity.username if entity.is_a?(User)
    name = entity.name if entity.is_a?(Group)
    respond_to do |format|
      data = {message: I18n.t('permissions.updated_entity', entity: name)}
      format.json { render :json => data, :status => :ok }
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
    param_rooms = params[:rooms]['approve_events']
    rooms = []
    if param_rooms.include?('all')
      rooms = Room.all
    else
      rooms = Room.all.select{ |room| param_rooms.include?(room.id.to_s)}
    end
    render :partial => "permitted_entities", locals: {users: User.all, groups: Group.all, rooms: rooms}
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
