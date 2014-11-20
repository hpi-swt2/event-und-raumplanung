class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, :check_ownership, only: [:show, :edit, :update, :destroy, :new_event_template]
  load_and_authorize_resource
  skip_load_and_authorize_resource :only =>[:index, :show, :new, :create, :new_event_template]


  def current_user
    unless session[:user_id]
      @current_user = User.new email: 'test@test.de' #Nur solange es keine Authentifikation gibt frag Micha
      session[:user_id] = @current_user.id
    end
    @current_user ||= User.find(session[:user_id])
  end

  # GET /events/1/new_event_template
  def new_event_template
    @event_template = EventTemplate.new
    @event_template.name = @event.name
    @event_template.description = @event.description
    @event_template.start_date = @event.start_date
    @event_template.end_date = @event.end_date
    @event_template.start_time = @event.start_time
    @event_template.end_time = @event.end_time
    @event_template.user_id = current_user.id
    render "event_templates/new"
  end

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
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
    @event.user_id = current_user.id

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

    def owner?(event=@event)
        event.user_id == current_user.id
    end

    def check_ownership
        raise  User::NotAuthorized unless owner?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:name, :description, :participant_count, :start_date, :end_date, :start_time, :end_time, :is_private, rooms:[:id])
    end
end
