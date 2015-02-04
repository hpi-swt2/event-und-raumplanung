class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @event_occurrences = Event.upcoming_events(5).select{|occ| can? :show, occ.event}
    @my_upcoming_events = next_five_own_events
    @requests = Event.open.order(:starts_at, :user_id, :id).select{|event| can? :approve, event}.first(5)
    get_my_tasks
    get_calendar_events
  end

  def get_calendar_events
    @calevents = Event.events_between(Time.current - 5.months, Time.now + 1.years).select{|occ| can? :show, occ.event}
    @favorites = Favorite.all
  end

  def events_between
    raise ActionController::ParameterMissing.new('start, end') unless events_between_params['start'].present? && events_between_params['end'].present?
    start_datetime = Time.parse(events_between_params['start'])
    end_datetime = Time.parse(events_between_params['end'])
    events = Event.events_between(start_datetime, end_datetime).select{|occ| can? :show, occ.event}
    events_json = "["
    events.each do |event_occurrence|
      events_json += event_occurrence.to_json
      events_json += ","
    end
    events_json = events_json[0..-2] if events_json.size > 1
    events_json += "]"
    respond_to do |format|
      format.html { render json: events_json }
      format.json { render json: events_json }
    end
  end
 private

  def events_between_params
    params.permit(:start, :end)
  end

  def get_my_tasks 
    @my_accepted_tasks = []
    @my_pending_tasks = []
    @group_pending_tasks = []
    @my_groups = current_user.groups
    current_events = Event.where("ends_at >= '#{(Time.current.to_s(:db))}'") 
    current_events.each do |event|
      @my_accepted_tasks += Task.where identity_type: 'User', identity_id: current_user.id, status: 'accepted', event_id: event.id, done: false
      @my_pending_tasks += Task.where identity_type: 'User', identity_id: current_user.id, status: 'pending', event_id: event.id
      @group_pending_tasks += Task.where identity_type: 'Group', identity_id: @my_groups, status: 'pending', event_id: event.id
    end

    accepted_event_ids = @my_accepted_tasks.collect{ |task| task.event_id }.uniq
    pending_event_ids = @my_pending_tasks.collect{ |task| task.event_id }.uniq
    pending_group_event_ids = @group_pending_tasks.collect{ |task| task.event_id }.uniq
    @my_accepted_events = Event.find(accepted_event_ids)
    @my_pending_events = Event.find(pending_event_ids)
    @group_pending_events = Event.find(pending_group_event_ids)
  end

  def next_five_own_events
    return Event.where("(ends_at >= '#{(Time.current.to_s(:db))}') AND (user_id = #{current_user.id}) ").order('starts_at ASC').limit(5)
  end
end
