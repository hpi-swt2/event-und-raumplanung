class DashboardController < ApplicationController
	before_action :authenticate_user!

	def index
   		@events = next_five_events
		get_my_tasks	
 	end

  	private

    def next_five_events
      return Event.where("starts_at >= '#{(Time.current.to_s(:db))}'").order('starts_at ASC').limit(5)
    end

	def get_my_tasks 
		@my_accepted_tasks = Task.where user_id: current_user.id, status: 'accepted'
		@my_pending_tasks = Task.where user_id: current_user.id, status: 'pending'
		accepted_event_ids = @my_accepted_tasks.collect{ |task| task.event_id }.uniq
		pending_event_ids = @my_pending_tasks.collect{ |task| task.event_id }.uniq
		@my_accepted_events = Event.find(accepted_event_ids).select{ |event| event.ends_at > Date.today }
		@my_pending_events = Event.find(pending_event_ids).select{ |event| event.ends_at > Date.today }
	end

end