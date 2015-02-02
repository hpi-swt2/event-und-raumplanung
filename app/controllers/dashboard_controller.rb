class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @event_occurrences = Event.upcoming_events(5)
    @my_upcoming_events = next_five_own_events
    get_my_tasks
  end

  def get_calendar_events
    return Event.events_between(Time.current - 5.months, Time.now + 1.years).select{|occ| can? :show, occ.event}
  end
  helper_method :get_calendar_events

 private

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
