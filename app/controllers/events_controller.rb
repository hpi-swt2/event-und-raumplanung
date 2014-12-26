class EventsController < GenericEventsController
  skip_filter :verify_authenticity_token, :check_vacancy
 # skip_filter :authenticate_user, :check_vacancy
  skip_before_filter :authenticate_user!
  before_action :authenticate_user!

  before_action :set_event, only: [:show, :edit, :update, :destroy, :approve, :decline, :new_event_template, :new_event_suggestion, :index_toggle_favorite , :show_toggle_favorite]
  before_action :set_return_url, only: [:show, :new, :edit]

  load_and_authorize_resource
  skip_load_and_authorize_resource :only =>[:index, :show, :new, :create, :new_event_template, :reset_filterrific, :check_vacancy, :new_event_suggestion, :decline, :approve, :index_toggle_favorite, :show_toggle_favorite]
  after_filter :flash_to_headers, :only => :check_vacancy
  
  before_action :get_instance_variable, only: [:new, :create, :update, :destroy]
  before_action :get_model, only: [:new, :create, :update, :destroy]
  
  def flash_to_headers
    if request.xhr?
      #avoiding XSS injections via flash
      flash_json = Hash[flash.map{|k,v| [k,ERB::Util.h(v)] }].to_json
      response.headers['X-Flash-Messages'] = flash_json
      flash.discard
    end
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

  def new_event_suggestion
    @event_suggestion = EventSuggestion.new
    @event_suggestion.starts_at = @event.starts_at
    @event_suggestion.ends_at = @event.ends_at
    @event_suggestion.rooms = @event.rooms
    @event_suggestion.user_id = @event.user_id
    @event_suggestion.event_id = @event.id
    render "event_suggestions/new"
  end

  # GET /events
  # GET /events.json
  def index
    @filterrific = Filterrific.new(Event,params[:filterrific] || session[:filterrific_events])
    @filterrific.select_options =  {sorted_by: Event.options_for_sorted_by, items_per_page: Event.options_for_per_page}
    @filterrific.user = current_user_id if @filterrific.user == 1;
    @filterrific.user = nil if @filterrific.user == 0;
    @events = Event.filterrific_find(@filterrific).page(params[:page]).per_page(@filterrific.items_per_page || Event.per_page)
    @favorites = Event.joins(:favorites).where('favorites.user_id = ? AND favorites.is_favorite=true',current_user_id).select('events.id')
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
    @event.update(status: 'approved')
    redirect_to events_approval_path(date: params[:date]) #params are not checked as date is no attribute of event and passed on as a html parameter
  end

  def decline
    @event.update(status: 'declined')
    redirect_to events_approval_path(date: params[:date]) #params are not checked as date is no attribute of event and passed on as a html parameter
  end

  def check_vacancy
    @event = Event.new(event_params)
    @event.user_id = current_user_id
    conflicting_events = @event.check_vacancy event_params[:room_ids]
    respond_to do |format|
      msg = conflicting_events_msg conflicting_events
      format.json { render :json => msg}
    end
  end

  def conflicting_events_msg events
    msg = {}
    if events.empty?
      msg[:status] = true
    else  
      msg = build_conflicting_events_response events
    end 
    return msg
  end 

  # GET /events/1
  # GET /events/1.json
  def show
    @favorite = Favorite.where('user_id = ? AND favorites.is_favorite=true AND event_id = ?',current_user_id,@event.id);
    @user = User.find(@event.user_id).identity_url unless @event.user_id.nil?
    logger.info @event.rooms.inspect
    @tasks = @event.tasks.rank(:task_order)
  end

  # GET /events/new
  def new
    super
  end 
  #   @event = Event.new
  #   @event.setDefaultTime
  # end

  # GET /events/1/edit
  def edit
    #authorize! :edit, @event
  end

  def sugguest
  end

  # POST /events
  # POST /events.json
  def create
    super
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    @update_result = @event.update(event_params)
    super
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    super
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:event_id, :name, :description, :participant_count, :starts_at_date, :starts_at_time, :ends_at_date, :ends_at_time, :is_private, :is_important, :show_only_my_events, :message, :commit,:room_ids => [])
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
      @return_url = tasks_path
      @return_url = root_path if request.referrer && URI(request.referer).path == root_path
    end

    def build_conflicting_events_response conflicting_events 
      msg = Hash[conflicting_events.map { |conflicting_event|
                  conflicting_event_name = conflicting_event.name if (conflicting_event.user_id == current_user_id || !conflicting_event.is_private)
                  room_msg = conflicting_event.rooms.pluck(:name).to_sentence
                  warning = get_conflicting_events_warning_msg conflicting_event, room_msg, conflicting_event_name
                  [ conflicting_event.id, { :msg => warning } ]
                }]
      msg[:status] = false
      return msg
    end

    def get_conflicting_events_warning_msg conflicting_event, room_msg, conflicting_event_name
      start_time = I18n.l conflicting_event.starts_at, format: :time_only
      end_time = I18n.l conflicting_event.ends_at, format: :time_only
      if conflicting_event.rooms.size > 1
        if same_day conflicting_event.starts_at, conflicting_event.ends_at 
          return I18n.t('event.alert.conflict_same_days_multiple_rooms', name: conflicting_event_name, start_date: conflicting_event.starts_at.strftime("%d.%m.%Y"), start_time: start_time, end_time: end_time, rooms: room_msg)
        else 
          return I18n.t('event.alert.conflict_different_days_multiple_rooms', name: conflicting_event_name, start_date: conflicting_event.starts_at.strftime("%d.%m.%Y"), end_date: conflicting_event.ends_at.strftime("%d.%m.%Y"), start_time: start_time, end_time: end_time, rooms: room_msg)
        end
      else
        if same_day conflicting_event.starts_at, conflicting_event.ends_at 
          return I18n.t('event.alert.conflict_same_days_one_room', name: conflicting_event_name, start_date: conflicting_event.starts_at.strftime("%d.%m.%Y"), start_time: start_time, end_time: end_time, rooms: room_msg)
        else
          return I18n.t('event.alert.conflict_different_days_one_room', name: conflicting_event_name, start_date: conflicting_event.starts_at.strftime("%d.%m.%Y"), end_date: conflicting_event.ends_at.strftime("%d.%m.%Y"), start_time: start_time, end_time: end_time, rooms: room_msg)
        end 
      end 
    end 

    def same_day starts_at, ends_at
      Time.at(starts_at).to_date === Time.at(ends_at).to_date
    end 
end
