class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy, :approve, :decline]
  load_and_authorize_resource
  skip_load_and_authorize_resource :only =>[:index, :show, :new, :create, :approve, :decline]
  # GET /events
  # GET /events.json
  def index
    @events = Event.all
  end

  def approve
    puts "approve"
    @event.update(approved: true)
    redirect_to approveevents_path(date: params[:date]) #params are not checked as date is no attribute of event and passed on as a html parameter
  end

  def decline
    puts "decline"
    @event.update(approved: false)
    redirect_to approveevents_path(date: params[:date]) #params are not checked as date is no attribute of event and passed on as a html parameter
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    #authorize! :edit, @event
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: t('notices.successful_create', :model => Event.model_name.human) }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: t('notices.successful_update', :model => Event.model_name.human) }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: t('notices.successful_destroy', :model => Event.model_name.human) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:name, :description, :participant_count, :start_date, :end_date, :start_time, :end_time)
    end
end
