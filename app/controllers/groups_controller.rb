class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:show, :edit, :update, :destroy, :manage_rooms, :assign_room ,:unassign_room, :assign_user, :unassign_user, :promote_user, :degrade_user]
  before_action :set_room, only: [:assign_room ,:unassign_room]
  before_action :set_user, only: [:assign_user, :unassign_user, :promote_user, :degrade_user]

  def index
    @groups = Group.all
  end

  def show
    @users = User.all
  end

  def assign_user
    authorize! :update, Group

    @group.users << @user
    redirect_to edit_group_path(@group)
  end

  def unassign_user
    authorize! :update, Group

    @group.users.delete(@user)
    redirect_to edit_group_path(@group)
  end

  def new
    # Only authorized users can create a group (ability.rb)
    authorize! :new, Group

    @group = Group.new    
  end

  def edit
    # Only authorized users can edit groups (ability.rb)
    authorize! :update, Group

    @users = User.all
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
    authorize! :update, Group

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
    authorize! :update, Group
    
    @unassigned_rooms = Room.where(:group_id => nil)
  end

  def assign_room
    authorize! :update, Group

    if @room.group == nil  
      @group.rooms << @room
      flash[:notice] = "Raum "+@room.name+" erfolgreich hinzugefügt."
    else
      flash[:warning] = "Raum "+@room.name+" bereits an Gruppe "+@room.group.name+" vergeben."
    end
    redirect_to manage_rooms_group_path(@group)
  end

  def unassign_room
    authorize! :update, Group

    @group.rooms.delete(@room)
    flash[:notice] = "Raum "+@room.name+" erfolgreich gelöscht."
    redirect_to manage_rooms_group_path(@group)
  end

  def promote_user
    # authorize! :update, Group
    mem = @user.memberships.select{|membership| membership.group_id == @group.id}.first
    mem.isLeader = true
    mem.save()
    redirect_to edit_group_path(@group)
  end

  def degrade_user
    # authorize! :update, Group
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
    def is_group_leader
      return current_user.membership.find_by(:group,@group).isLeader
    end
end
