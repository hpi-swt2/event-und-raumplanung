class RoomPropertiesController < ApplicationController
  
  before_action :set_room_property, only: [:show, :edit, :update, :destroy]

  # GET /rooms
  # GET /rooms.json
  def index
    @roomProperties = RoomProperty.all
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
  end

  # GET /rooms/new
  def new
    @roomProperty = RoomProperty.new
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @roomProperty = RoomProperty.new(room_property_params)

    respond_to do |format|
      if @roomProperty.save
        format.html { redirect_to @roomProperty, notice: t('notices.successful_create', :model => RoomProperty.model_name.human) }
        format.json { render :show, status: :created, location: @roomProperty }
      else
        format.html { render :new }
        format.json { render json: @roomProperty.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    respond_to do |format|
      if @roomProperty.update(room_property_params)
        format.html { redirect_to @roomProperty, notice: t('notices.successful_update', :model => RoomProperty.model_name.human) }
        format.json { render :show, status: :ok, location: @roomProperty }
      else
        format.html { render :edit }
        format.json { render json: @roomProperty.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @roomProperty.destroy
    respond_to do |format|
      format.html { redirect_to room_properties_url, notice: t('notices.successful_destroy', :model => RoomProperty.model_name.human) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room_property
      @roomProperty = RoomProperty.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_property_params
      params.require(:room_property).permit(:name)
    end

end
