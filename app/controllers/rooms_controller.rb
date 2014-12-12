class RoomsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_room, only: [:show, :edit, :update, :destroy, :details, :list_events]
  before_action :set_all_properties, only: [:edit, :new]

  # GET /rooms
  # GET /rooms.json
  def index
    @rooms = Room.all
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
    @events = @room.upcoming_events.take(5)
  end

  # GET /rooms/new
  def new
    @room = Room.new
    authorize! :new, @room
  end

  def list
    @categories = Equipment.group(:category).pluck(:category)
    @properties = RoomProperty.group(:name).pluck(:name)
    @empty = false;
    @noSelection = false
    rooms_ids = Room.all.pluck(:id)
    if params.size <= 4
        if params[:room].nil? or params[:room][:size].empty?
	        @noSelection = true
        end
    end
    if !params[:room].nil? and !params[:room][:size].empty?
      @size = params[:room][:size]
      rooms_ids = rooms_ids & Room.where('size >= ?', @size).pluck(:id)
     end
     @categories.each do |category|
     	if params.has_key?(category)
	  rooms_ids = rooms_ids & Equipment.where(:category => category).pluck(:room_id)
     	end
     end
     @properties.each do |name|
         if params.has_key?(name)
             rooms_ids = rooms_ids & RoomProperty.where(:name => name).pluck(:room_id)
         end
     end
     if rooms_ids.empty?
	 @empty = true
     end
     @rooms = Room.find(rooms_ids)
  end

  def getValidRooms
    needed_rooms = Equipment.where("category IN (?)", params['room']['equipment']).pluck(:room_id)
    needed_rooms = Room.where("id IN (:rooms) and size >= :room_size", { :rooms => needed_rooms, :room_size => params['room']['size']})
    msg = Hash[needed_rooms.map { |room| [room.id, {"name" => room.name}]}]

    respond_to do |format|
        format.json { render :json => msg} 
    end 
  end 

  # GET /rooms/1/edit
  def edit
    authorize! :edit, @room
  end

  # GET /rooms/1/events
  def list_events
    @events = @room.upcoming_events
    render 'events'
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(room_params)
    authorize! :create, @room

    respond_to do |format|
      if @room.save
        format.html { redirect_to rooms_path, notice: t('notices.successful_create', :model => Room.model_name.human) }
        format.json { render :show, status: :created, location: @room }
      else
        format.html { render :new }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    authorize! :update, @room

    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to rooms_path, notice: t('notices.successful_update', :model => Room.model_name.human) }
        format.json { render :show, status: :ok, location: @room }
      else
        format.html { render :edit }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    authorize! :destroy, @room
    @room.destroy
    respond_to do |format|
      format.html { redirect_to rooms_url, notice: t('notices.successful_destroy', :model => Room.model_name.human) }
      format.json { head :no_content }
    end
  end
  
  def details
	render action: 'details'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    def set_all_properties
      @properties = RoomProperty.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:name, :size, :property_ids => [])
    end
end
