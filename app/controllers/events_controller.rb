class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:show, :edit, :update, :destroy, :new_event_template]
  load_and_authorize_resource
  skip_load_and_authorize_resource :only =>[:index, :show, :new, :create, :new_event_template, :reset_filterrific]

  def current_user_id
    current_user.id
  end

  # GET /events/1/new_event_template
  def new_event_template
    @event_template = EventTemplate.new
    @event_template.name = @event.name
    @event_template.description = @event.description
    @event_template.user_id = current_user_id
    render "event_templates/new"
  end

  # GET /events
  # GET /events.json
  def index

     
     @filterrific = Filterrific.new(
      Event,
      params[:filterrific] || session[:filterrific_events])
      @filterrific.select_options =   {
        sorted_by: Event.options_for_sorted_by
      }
      @filterrific.own = if @filterrific.own == 1
          current_user_id
        else
          nil
        end
      @events = Event.filterrific_find(@filterrific).page(params[:page])

      session[:filterrific_events] = @filterrific.to_hash


    respond_to do |format|
      format.html
      format.js
    end
  end

  def reset_filterrific
    # Clear session persistence
    session[:filterrific_events] = nil
    # Redirect back to the index action for default filter settings.
    redirect_to action: :index
  end


  # GET /events/1
  # GET /events/1.json
  def show
    @user = User.find(@event.user_id).identity_url
  end

  # GET /events/new
  def new
    @event = Event.new
    time = Time.new.getlocal
    time -= time.sec
    time += time.min % 15
    @event.starts_at = time
    @event.ends_at = (time+(60*60))
  end

  # GET /events/1/edit
  def edit
    #authorize! :edit, @event
  end

  # POST /events
  # POST /events.json
  def create
    temp_event_params = event_params
    temp = [] 
    temp_event_params[:rooms].each do | room_id | 
      begin 
        room = Room.find(room_id)
      rescue ActiveRecord::RecordNotFound  
        next 
      else  
        temp << room
      end 
    end   
      
    temp_event_params[:rooms] = temp
    @event = Event.new(temp_event_params)
    @event.user_id = current_user_id

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

      temp_event_params = event_params
      temp = [] 
      temp_event_params[:rooms].each do | room_id | 
        begin 
          room = Room.find(room_id)
        rescue ActiveRecord::RecordNotFound  
          next 
        else  
        temp << room
        end 
      end  
      
      temp_event_params[:rooms] = temp

      if @event.update(temp_event_params)
        format.html { redirect_to @event, notice: t('notices.successful_update', :model => Event.model_name.human) }
       # format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
       # format.json { render json: @event.errors, status: :unprocessable_entity }
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
      params.require(:event).permit(:name, :description, :participant_count, :starts_at_date, :starts_at_time, :ends_at_date, :ends_at_time, :is_private, :show_only_my_events, rooms:[:id])
    end
end
