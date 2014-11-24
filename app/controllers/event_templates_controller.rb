class EventTemplatesController < ApplicationController
  include EventTemplatesHelper
  before_action :set_event_template, only: [:show, :edit, :update, :destroy, :new_event]
  load_and_authorize_resource
  skip_load_and_authorize_resource :only =>[:index, :show, :new, :create, :new_event]

  def current_user_id
    current_user.id
  end

  # GET /templates
  # GET /templates.json
  def index
    @event_templates = EventTemplate.from_user(current_user_id)
  end

  # GET /templates/1
  # GET /templates/1.json
  def show
  end

  # GET /templates/new
  def new
    @event_template = EventTemplate.new
  end

   # GET /templates/1/new_event
  def new_event
    @event = Event.new
    time = Time.new.getlocal
    time -= time.sec
    time += time.min % 15
    @event.starts_at = time
    @event.ends_at = (time+(60*60))
    @event.name = @event_template.name
    @event.description = @event_template.description
    render "events/new"
  end

  # GET /templates/1/edit
  def edit
  end

  # POST /templates
  # POST /templates.json
  def create
    @event_template = EventTemplate.new(eventtemplate_params)
    @event_template.user_id = current_user_id

    respond_to do |format|
      if @event_template.save
        format.html { redirect_to @event_template, notice: t('notices.successful_create', :model => EventTemplate.model_name.human) }
        format.json { render :show, status: :created, location: @event_template }
      else
        format.html { render :new }
        format.json { render json: @event_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /templates/1
  # PATCH/PUT /templates/1.json
  def update
    respond_to do |format|
      if @event_template.update(eventtemplate_params)
        format.html { redirect_to @event_template, notice: t('notices.successful_update', :model => EventTemplate.model_name.human) }
        format.json { render :show, status: :ok, location: @event_template }
      else
        format.html { render :edit }
        format.json { render json: @event_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /templates/1
  # DELETE /templates/1.json
  def destroy
    @event_template.destroy
    respond_to do |format|
      format.html { redirect_to event_templates_url, notice: t('notices.successful_destroy', :model => EventTemplate.model_name.human) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_template
      @event_template = EventTemplate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def eventtemplate_params
      params.require(:event_template).permit(:name, :description, :start_date, :end_date, :start_time, :end_time)
    end
end
