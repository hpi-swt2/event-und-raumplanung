class EventsController < GenericEventsController
  skip_filter :verify_authenticity_token, :check_vacancy
 # skip_filter :authenticate_user, :check_vacancy
  skip_before_filter :authenticate_user!
  before_action :authenticate_user!

  before_action :set_event, only: [:show, :edit, :update, :destroy, :approve, :decline, :new_event_template, :new_event_suggestion, :index_toggle_favorite , :show_toggle_favorite, :decline_event_suggestion, :approve_event_suggestion, :edit_event_with_suggestion, :update_event_with_suggestion]
  before_action :set_return_url, only: [:show, :new, :edit]
  before_action :set_feed, only: [:show]

  #respond_to :html, :js

  load_and_authorize_resource
  skip_load_and_authorize_resource :only =>[:index, :show, :new, :create, :new_event_template, :reset_filterrific, :check_vacancy, :new_event_suggestion, :decline, :approve, :index_toggle_favorite, :show_toggle_favorite, :create_event_suggestion, :edit_event_with_suggestion]
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

  # GET /events/:id/new_event_template
  def new_event_template
    @event_template = EventTemplate.new
    @event_template.name = @event.name
    @event_template.description = @event.description
    @event_template.participant_count = @event.participant_count
    @event_template.rooms = @event.rooms
    @event_id = @event.id
    render "event_templates/new"
  end

  #GET /events/:id/index_toggle_favorite
  def index_toggle_favorite
    toggle_favorite
    redirect_to events_url
  end

  # GET /events/:id/show_toggle_favorite
  def show_toggle_favorite
    toggle_favorite
    redirect_to event_url
  end

  # GET /events
  # GET /events.json
  def index
    @filterrific = Filterrific.new(Event, params[:filterrific] || session[:filterrific_events])
    @filterrific.select_options =  {sorted_by: Event.options_for_sorted_by, items_per_page: Event.options_for_per_page}
    @filterrific.user = current_user_id if @filterrific.user == 1 || params[:only_own];
    @filterrific.user = nil if @filterrific.user == 0;
    @events = Event.filterrific_find(@filterrific).page(params[:page]).per_page(@filterrific.items_per_page || Event.per_page)
    @favorites = Event.joins(:favorites).where('favorites.user_id = ? AND favorites.is_favorite = ?', current_user_id, true).select('events.id')
    session[:filterrific_events] = @filterrific.to_hash
  end

  def reset_filterrific
    # Clear session persistence
    session[:filterrific_events] = nil
    # Redirect back to the index action for default filter settings.
    redirect_to action: :index
  end

  def approve
    @event.approve
    @event.activities << Activity.create(:username => current_user.username,
                                          :action => params[:action],
                                          :controller => params[:controller])
    redirect_to :back
  end

  def decline
    @event.decline
    @event.activities << Activity.create(:username => current_user.username, 
                                          :action => params[:action],
                                          :controller => params[:controller])
    redirect_to :back
  end

  def approve_event_suggestion
  #  if !params.has_key?(:message) or params[:message] == nil or params[:message].strip.empty?
  #    if User.exists?(@event.user_id)
  #      UserMailer.event_accepted_email_without_message(User.find(@event.user_id), @event).deliver;
  #    end
  #  else
  #    if User.exists?(@event.user_id)
  #      UserMailer.event_accepted_email_with_message(User.find(@event.user_id), @event, params[:message]).deliver;
  #    end
  #  end
    @event.update(status: 'pending', event_id: nil)
    redirect_to events_path, notice: t('notices.successful_approve', :model => t('event.status.suggested'))

  end

  def decline_event_suggestion
  #  if !params.has_key?(:message) or params[:message] == nil or params[:message].strip.empty?
  #    if User.exists?(@event.user_id)
  #      UserMailer.event_declined_email_without_message(User.find(@event.user_id), @event).deliver;
  #    end
  #  else
  #    if User.exists?(@event.user_id)
  #      UserMailer.event_declined_email_with_message(User.find(@event.user_id), @event, params[:message]).deliver;
  #    end
  #  end

    if @event.update(:status => 'rejected_suggestion')
      respond_to do |format|
        format.html { redirect_to events_path, notice: t('notices.successful_decline', :model => t('event.status.suggested')) }
        format.json { head :no_content }
      end
    end
  end

  def check_vacancy
    @event = Event.new(event_suggestion_params.except(:original_event_id))
    @event.user_id = current_user_id
    conflicting_events = @event.check_vacancy event_suggestion_params[:original_event_id], event_suggestion_params[:room_ids]
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
    @favorite = Favorite.where('user_id = ? AND favorites.is_favorite = ? AND event_id = ?', current_user_id, true, @event.id);
    @user = User.find(@event.user_id).name unless @event.user_id.nil?
    if current_user_id == @event.user_id
      @tasks = @event.tasks.rank(:task_order)
    else
      @tasks = @event.tasks.where('identity_type = \'User\' AND identity_id = ?', current_user_id).rank(:task_order)
    end
  end

  # GET /events/new
  def new
    super
    @event.assign_attributes(params.permit(:name, :description, :participant_count, :starts_at, :ends_at, :is_private, :is_important, :room_ids => []))
  end 

  # GET /events/:id/new_event_suggestion
  def new_event_suggestion
    @original_event_id = @event.id
    render "event_suggestions/new"
  end

  # GET /events/1/edit 
  def edit
    #authorize! :edit, @event
  end

  # POST /events
  # POST /events.json
  def create

    create_event event_params, :new, Event.model_name.human
  end

  # POST /events/event_suggestion
  def create_event_suggestion
    params = add_original_event_params event_suggestion_params
    params = add_reference_to_original_event params 
    create_event params, "event_suggestions/new", 'Vorschlag'
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    @event.schedule_from_rule(event_params[:occurence_rule])
    filtered_params = params_without_occurence_rule(event_params)
    @event.attributes = filtered_params

    changed_attributes = @event.changed

    @update_result = @event.update(filtered_params)

    if @update_result
      @event.activities << Activity.create(:username => current_user.username, 
                                          :action => params[:action], :controller => params[:controller],
                                          :changed_fields => changed_attributes)
    end
    super
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    super
  end


  def create_comment
    @comment = Comments.new(:content => params[:commentContent], :user_id => params[:user_id], :event_id => params[:event_id])
    respond_to do |format|
      if @comment.save
        format.html { redirect_to events_url + "/" + params[:event_id], notice: t('notices.successful_create', :model => Comments.model_name.human) }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end
  helper_method :create_comment

  def delete_comment
    @comment = Comments.find(params[:comment_id])
    @comment.destroy
    respond_to do |format|
        format.html { redirect_to events_url + "/" + params[:event_id], notice: t('notices.successful_destroy', :model => Event.model_name.human) }
        format.json { render :show, status: :created, location: @comment }
    end
  end
  helper_method :delete_comment

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:name, :description, :participant_count, :starts_at_date, :starts_at_time, :ends_at_date, :ends_at_time, :is_private, :is_important, :show_only_my_events, :message, :event_template_id, :commit, :occurence_rule, :schedule, :room_ids => [])
    end

    def params_without_occurence_rule(params)
      params.reject {|k,v| k == "occurence_rule"}
    end

    def event_suggestion_params
      params.require(:event).permit(:starts_at_date, :starts_at_time, :ends_at_date, :ends_at_time, :original_event_id, :message,:room_ids => [])
    end

    def create_event params, new_url, model
      @event_template_id = params['event_template_id']
      params.delete('event_template_id')
      @event = Event.new(params_without_occurence_rule params)
      @event.schedule_from_rule(params[:occurence_rule])
      @event.user_id = current_user_id
      create_tasks @event_template_id

      respond_to do |format|
        if @event.save
          @event.activities << Activity.create(:username => current_user.username, 
                                          :action => "create", :controller => "events",
                                          :changed_fields => @event.changed)

          format.html { redirect_to @event, notice: t('notices.successful_create', :model => model) } # redirect to overview
          format.json { render :show, status: :created, location: @event }
        else
          if params['event_id']
            @original_event_id = params['event_id']
          end
          format.html { render new_url}
          format.json { render json: @event.errors, status: :unprocessable_entity }
        end
      end
    end

    def create_tasks event_template_id
      if event_template_id
        event_template = EventTemplate.find(event_template_id)
        event_template.tasks.collect do |original_task| 
          event_task = original_task.dup
          event_task = create_tasks_with_attachments original_task, event_task
          event_task.event_template_id = nil
          @event.tasks << event_task 
        end
      end
      return 
    end

    def create_tasks_with_attachments original_task, new_task
      original_task.attachments.collect do |original_attachments| 
        event_attachment = original_attachments.dup 
        new_task.attachments << event_attachment
      end
      return new_task
    end          

    def add_original_event_params params
      @event = Event.find(params['original_event_id'])
      params['name'] = @event.name
      params['description'] = @event.description
      params['participant_count'] = @event.participant_count
      params['is_private'] = @event.is_private
      params['is_important'] = @event.is_important
      params['status'] = 'suggested'
      return params
    end

    def add_reference_to_original_event params
      params['event_id'] = params['original_event_id']
      params.delete('original_event_id')
      return params
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

    def set_feed
      if @event.involved_users.include? current_user or can? :manage, Event
        @activities = @event.activities.all.order("created_at ASC")
        @comments = Comments.where(event_id: @event.id)
        @feed_entries = @activities + @comments
        @feed_entries = @feed_entries.sort_by(&:created_at)
      end
    end

    def build_conflicting_events_response conflicting_events 
      logger.info conflicting_events.inspect
      msg = Hash[conflicting_events.map { |conflicting_event|
                  conflicting_event_name = (conflicting_event.user_id == current_user_id || !conflicting_event.is_private) ? conflicting_event.name : "Privates Event"
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
      rooms_translation = conflicting_event.rooms.size > 1 ? 'multiple_rooms' : 'one_room'
      days_translation = (same_day conflicting_event.starts_at, conflicting_event.ends_at )? 'same_days' : 'different_days'
      return I18n.t('event.alert.conflict_'+ days_translation + '_' + rooms_translation, name: conflicting_event_name, start_date: conflicting_event.starts_at.strftime("%d.%m.%Y"), end_date: conflicting_event.ends_at.strftime("%d.%m.%Y"), start_time: start_time, end_time: end_time, rooms: room_msg)
    end 

    def same_day starts_at, ends_at
      Time.at(starts_at).to_date === Time.at(ends_at).to_date
    end 

end
