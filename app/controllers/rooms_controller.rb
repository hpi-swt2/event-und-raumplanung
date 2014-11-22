class RoomsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_room, only: [:show, :edit, :update, :destroy, :list_events]


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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:name, :size)
    end
end
