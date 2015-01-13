class EquipmentController < ApplicationController
  before_action :authenticate_user!
  before_action :set_equipment, only: [:show, :edit, :update, :destroy]

  # GET /equipment
  # GET /equipment.json
  def index
    @equipment = Equipment.all
  end

  # GET /equipment/1
  # GET /equipment/1.json
  def show
  end

  # GET /equipment/new
  def new
    @equipment = Equipment.new
    authorize! :new, @equipment
  end

  # GET /equipment/1/edit
  def edit
    authorize! :edit, @equipment
  end

  # POST /equipment
  # POST /equipment.json
  def create
    @equipment = Equipment.new(equipment_params)
    authorize! :create, @equipment
    respond_to do |format|
      if @equipment.save
        format.html { redirect_to equipment_index_url, notice: t('notices.successful_create', :model => Equipment.model_name.human) }
        format.json { render :show, status: :created, location: @equipment }
      else
        format.html { render :new }
        format.json { render json: @equipment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /equipment/1
  # PATCH/PUT /equipment/1.json
  def update
    authorize! :update, @equipment
    respond_to do |format|
      if @equipment.update(equipment_params)
        format.html { redirect_to equipment_index_url, notice: t('notices.successful_update', :model => Equipment.model_name.human) }
        format.json { render :show, status: :ok, location: @equipment }
      else
        format.html { render :edit }
        format.json { render json: @equipment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /equipment/1
  # DELETE /equipment/1.json
  def destroy
    authorize! :destroy, @equipment
    @equipment.destroy
    respond_to do |format|
      format.html { redirect_to equipment_index_url, notice: t('notices.successful_destroy', :model => Equipment.model_name.human) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_equipment
      @equipment = Equipment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def equipment_params
      params.require(:equipment).permit(:name, :description, :room_id, :category)
    end
end
