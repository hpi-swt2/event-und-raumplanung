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

  def permit_per_room(entity, permission)
    rooms_to_permit = []
    rooms_to_permit = params[:rooms][permission] if params[:rooms][permission].present?
    if rooms_to_permit.include?('all')
      entity.permit(permission)
      rooms_to_permit = []
    else
      entity.unpermit(permission)
    end
    Room.all.each do |room|
      if rooms_to_permit.include?(room.id.to_s)
        entity.permit(permission, room)
      else
        entity.unpermit(permission, room)
      end
    end
  end

  def submit_permissions
    entities = User.all + Group.all
    permission = permission_params[:permission]
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
        entity.unpermit_all(permission)
      end
    end
    respond_to do |format|
      data = {message: I18n.t('permissions.updated_permission', permission: I18n.t('permissions.' + permission))}
      format.json { render :json => data, :status => :ok }
    end
  end

  def submit_entities
    entity = determine_permitted_entity(entity_params[:entity])
    Permission.categories.keys.each do |permission|
      if entity_params[permission] == "1"
        if permission != 'approve_events'
          entity.permit(permission)
        else
          permit_per_room(entity, permission)
        end
      else
        entity.unpermit_all(permission)
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

  def checkboxes_by_permission
    params.permit(:permission)
    @permission = params[:permission]
    rooms_for_approve_events = params[:rooms]['approve_events']
    rooms = []
    if rooms_for_approve_events.include?('all')
      rooms = Room.all
    else
      rooms = Room.all.select{ |room| rooms_for_approve_events.include?(room.id.to_s)}
    end
    render :partial => "checkboxes_by_permission", locals: {users: User.all, groups: Group.all, rooms: rooms}
  end

  def checkboxes_by_entity
    params.permit(:entity)
    @permitted_entity = determine_permitted_entity(params[:entity])
    @categories = Permission.categories.keys
    render :partial => "checkboxes_by_entity"
  end

  def authorize_admin
    authorize! :manage, Permission
  end

  def entity_params
    params.permit(:entity)
    Permission.categories.keys.each do |permission|
      params.permit(permission)
    end
    return params
  end

  def permission_params
    params.permit(:permission)
    return params
  end  

end
