class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:show, :edit, :update, :destroy, :manage_rooms,:unassign_room, :assign_user, :unassign_user, :promote_user, :degrade_user, :current_ability, :assign_rooms]
  before_action :set_room, only: [:unassign_room]
  before_action :set_user, only: [:promote_user, :degrade_user, :current_ability]
  before_action :get_user_roles, only: [:show, :edit]
  before_action :load_user_from_email, only: [:assign_user]
  before_action :load_user_from_id, only: [:unassign_user]

  def index
    @groups = Group.all
  end

  def show
    @users = @group.users 
  end
    
  def assign_user
    authorize! :assign_user, @group
    flash[:notice] = t('notices.successful_user_assign', :email => @user.email)
    @group.users << @user
    redirect_to edit_group_path(@group)
  end

  def unassign_user
    authorize! :unassign_user, @group
    if @user.is_leader_of_group(@group.id) == false
      flash[:notice] = t('notices.successful_user_unassign', :email => @user.email)
      @group.users.delete(@user)
    else
      flash[:error] = t('errors.messages.unsuccessful_user_unassign', :email => @user.email)
    end
    redirect_to edit_group_path(@group)
  end

  def new
    authorize! :new, Group

    @group = Group.new    
  end

  def edit
    authorize! :edit, @group
    @users = @group.users
  end

  def create
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

  def assign_rooms
    authorize! :manage_rooms, Group
    room_ids = params[:group][:room_ids]
    room_ids.delete("")
    if room_ids.any?
      room_ids.each do |room_id|
        if  Room.find(room_id).group == nil 
          @group.rooms <<  Room.find(room_id)
        end
      end
      flash[:notice] = "Räume erfolgreich hinzugefügt."
    else
      flash[:error] = "Kein Raum ausgewählt."
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
      flash[:notice] = t('notices.successful_promotion', :email => @user.email)
    else
      flash[:error] = t('errors.messages.unsuccessful_promotion', :email => @user.email)
    end
    redirect_to edit_group_path(@group)
  end

  def degrade_user
    authorize! :degrade_user, Group
    if @user.is_member_of_group(@group)
      mem = @user.memberships.select{|membership| membership.group_id == @group.id}.first
      mem.isLeader = false
      mem.save()
      flash[:notice] = t('notices.successful_degradation', :email => @user.email)
    else
      flash[:error] = t('errors.messages.unsuccessful_degradation', :email => @user.email)
    end
    redirect_to edit_group_path(@group)
  end

  private
    def set_group
      @group = Group.find(params[:id])
    end

    def load_user_from_email
      if params.include?(:User)
        @user = User.find_by_email(params[:User][:email])
        if @user == nil
          flash[:error] = t("groups.edit.user_not_found")
          redirect_to edit_group_path(@group)
        end
      end
    end

    def load_user_from_id
      if params.include?(:user_id)
        @user = User.find(params[:user_id])
        if @user == nil
          flash[:error] = t("groups.edit.user_not_found")
          redirect_to edit_group_path(@group)
        end
      end
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

    def set_user
      @user = User.find(params[:user_id])
    end
end