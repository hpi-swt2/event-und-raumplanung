class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    #@events = next_five_events
    @events = Event.upcoming_events(5)
    get_my_tasks
  end

  private

  # To be replaced by upcoming_events from events_helper
  #def next_five_events
  #  return Event.where("starts_at >= '#{(Time.current.to_s(:db))}'").order('starts_at ASC').limit(5)
  #end

  def get_my_tasks
    @my_accepted_tasks = []
    @my_pending_tasks = []
    current_events = Event.where("ends_at >= '#{(Time.current.to_s(:db))}'")
    current_events.each do |event|
      @my_accepted_tasks += Task.where user_id: current_user.id, status: 'accepted', event_id: event.id
      @my_pending_tasks += Task.where user_id: current_user.id, status: 'pending', event_id: event.id
    end

    accepted_event_ids = @my_accepted_tasks.collect{ |task| task.event_id }.uniq
    pending_event_ids = @my_pending_tasks.collect{ |task| task.event_id }.uniq
    @my_accepted_events = Event.find(accepted_event_ids)
    @my_pending_events = Event.find(pending_event_ids)
  end
end