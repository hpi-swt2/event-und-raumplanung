class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:show, :edit, :update, :destroy, :manage_rooms, :assign_room ,:unassign_room, :assign_user, :unassign_user, :promote_user, :degrade_user, :current_ability]
  before_action :set_room, only: [:assign_room ,:unassign_room]
  before_action :set_user, only: [:assign_user, :unassign_user, :promote_user, :degrade_user, :current_ability]
  before_action :get_user_roles, only: [:show, :edit]
  # before_action :current_ability, only: [:promote_user, :degrade_user]

  # load_and_authorize_resource

  def index
    @groups = Group.all
  end

  def show
    # authorize :assign_user, Group

  end

  def assign_user
    authorize! :assign_user, @group
    # authorize :assign_user, Group
    flash[:notice] = "Benutzer "+@user.identity_url+" erfolgreich der Gruppe hinzugefügt"
    @group.users << @user
    redirect_to edit_group_path(@group)
  end

  def unassign_user
    authorize! :unassign_user, @group
    if @user.is_leader_of_group(@group.id) == false
      flash[:notice] = "Benutzer "+@user.identity_url+" erfolgreich aus Gruppe entfernt"
      @group.users.delete(@user)
    else
      flash[:error] = "Benutzer "+@user.identity_url+" kann nicht aus der Gruppe entfernt werden, da er Gruppenleiter ist."
    end
    redirect_to edit_group_path(@group)
  end

  def new
    # Only authorized users can create a group (ability.rb)
    authorize! :new, Group

    @group = Group.new    
  end

  def edit
    # Only authorized users can edit groups (ability.rb)
    authorize! :edit, @group
  end

  def create
    # Only authorized users can create a group (ability.rb)
    authorize! :create, Group

    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: t('notices.successful_create', :model => Group.model_name.human) }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    # Only authorized users can update groups (ability.rb)
    authorize! :update, @group

    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: t('notices.successful_update', :model => Group.model_name.human) }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # Only authorized users can delete a group (ability.rb)
    authorize! :destroy, Group

    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: t('notices.successful_destroy', :model => Group.model_name.human) }
      format.json { head :no_content }
    end
  end

  def manage_rooms
    authorize! :manage_rooms, Group
    
    @unassigned_rooms = Room.where(:group_id => nil)
  end

  def assign_room
    authorize! :manage_rooms, Group

    if @room.group == nil  
      @group.rooms << @room
      flash[:notice] = "Raum "+@room.name+" erfolgreich hinzugefügt."
    else
      flash[:error] = "Raum "+@room.name+" bereits an Gruppe "+@room.group.name+" vergeben."
    end
    redirect_to manage_rooms_group_path(@group)
  end

  def unassign_room
    authorize! :manage_rooms, Group

    @group.rooms.delete(@room)
    flash[:notice] = "Raum "+@room.name+" erfolgreich gelöscht."
    redirect_to manage_rooms_group_path(@group)
  end

  def promote_user
    authorize! :promote_user, Group
    if @user.is_member_of_group(@group)
      mem = @user.memberships.select{|membership| membership.group_id == @group.id}.first
      mem.isLeader = true
      mem.save()
      flash[:notice] = "Benutzer "+@user.identity_url+" erfolgreich zum Gruppenleiter ernannt"
    else
      flash[:error] = "Benutzer "+@user.identity_url+" ist kein Mitglied der Gruppe"
    end
    redirect_to edit_group_path(@group)
  end

  def degrade_user
    authorize! :degrade_user, Group
    mem = @user.memberships.select{|membership| membership.group_id == @group.id}.first
    mem.isLeader = false
    mem.save()
    redirect_to edit_group_path(@group)
  end

  private
    def set_group
      @group = Group.find(params[:id])
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    def group_params
      params.require(:group).permit(:name)
    end
    def set_room
      @room = Room.find(params[:room_id])
    end
    def get_user_roles
      @users = User.all
      @leaders = @users.select{|u| u.is_leader_of_group(@group.id)}
      @members = @users.select{|u| u.is_member_of_group(@group.id) && u.is_leader_of_group(@group.id) == false}
      @nonmembers = @users.select{|u| u.is_member_of_group(@group.id) == false}
    end
    # def current_ability
      # @current_ability ||= Ability.new(current_user, @group)
    # end
end
