class DashboardController < ApplicationController
	before_action :authenticate_user!

	
	def index
		get_my_tasks

	end

	private

	def get_my_tasks 
		@my_tasks = Task.where user_id: current_user.id, status: 'accepted'
		event_ids = @my_tasks.collect{ |task| task.event_id }.uniq
		@my_events = Event.find(event_ids).select{ |event| event.ends_at > Date.today }
	end

end