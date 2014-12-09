class EventsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_event, only: [:show, :edit, :update, :destroy, :approve, :new_event_template, :index_toggle_favorite , :show_toggle_favorite]
  before_action :set_return_url, only: [:show, :new, :edit]
  load_and_authorize_resource
  skip_load_and_authorize_resource :only =>[:index, :show, :new, :create, :new_event_template, :index_toggle_favorite, :show_toggle_favorite, :reset_filterrific]

  def current_user_id
    current_user.id
  end

  # GET /events/1/new_event_template
  def new_event_template
    @event_template = EventTemplate.new
    @event_template.name = @event.name
    @event_template.description = @event.description
    @event_template.participant_count = @event.participant_count
    @event_template.rooms = @event.rooms
    render "event_templates/new"
  end

  #GET /events/1/index_toggle_favorite
  def index_toggle_favorite
    toggle_favorite
    redirect_to events_url
  end

  #GET /events/1/show_toggle_favorite
  def show_toggle_favorite
    toggle_favorite
    redirect_to event_url
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
      @filterrific.room_ids = Room.all.map(&:id) if @filterrific.room_ids && @filterrific.room_ids.size <=1
      @events = Event.filterrific_find(@filterrific).page(params[:page])
      @favorites = Event.joins(:favorites).where('favorites.user_id = ? AND favorites.is_favorite=true',current_user_id).select('events.id')
      puts @favorites
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

  def approve
    puts "approve"
    @event.update(approved: true)
    redirect_to events_approval_path(date: params[:date]) #params are not checked as date is no attribute of event and passed on as a html parameter
  end

  def decline
    puts "decline"
    @event.update(approved: false)
    redirect_to events_approval_path(date: params[:date]) #params are not checked as date is no attribute of event and passed on as a html parameter
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @favorite = Favorite.where('user_id = ? AND favorites.is_favorite=true AND event_id = ?',current_user_id,@event.id);
    @user = User.find(@event.user_id).identity_url
    @tasks = @event.tasks.rank(:task_order)
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
    @event = Event.new(event_params)
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
      if @event.update(event_params)
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
      params.require(:event).permit(:name, :description, :participant_count, :starts_at_date, :starts_at_time, :ends_at_date, :ends_at_time, :is_private, :show_only_my_events, :room_ids => [])
    end

    def toggle_favorite

      favorite = Favorite.where('user_id = ? AND event_id = ?',current_user_id,@event.id);
      if favorite.empty?
        Favorite.create(:user_id => current_user_id, :event_id => @event.id, :is_favorite => true)
      else
        if favorite.last().is_favorite?
          favorite.last().is_favorite = false
          favorite.last().save();
        else
          favorite.last().is_favorite = true
          favorite.last().save();
        end
      end
  end

    def set_return_url
      @return_url = params[:return_url]
    end
end
