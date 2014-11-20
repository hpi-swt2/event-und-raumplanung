class ApproveeventsController < ApplicationController

	before_action :read_and_exec_params
	def read_and_exec_params
		if params[:id] and params[:approved]
			Event.find(params[:id]).update(approved: params[:approved])
		end
		if params[:date]
			@date = params[:date].to_date
		else	
			@date = Date.today
		end
	end

  def list
  		@events = Event.all
  		@bookings = Booking.all
  		check_data
		@events = @events.where!(approved: nil)
		@bookings = @bookings.where('start BETWEEN ? AND ?', @date.beginning_of_day, @date.end_of_day).order(:start, :event_id)
  end

  def check_data
  	@events.where(name: nil).update_all(:name => 'generated name')
  	@events.where(description: nil).update_all(:description => 'generated description')
  	@events.where(start_time: nil).update_all(:start_time => Time.current)
  	@events.where(end_time: nil).update_all(:end_time => Time.current)
   	@events.where(start_date: nil).update_all(:start_date => Date.today)
  	@events.where(end_date: nil).update_all(:end_date => Date.today)

	@bookings.where(start: nil).update_all(:start => DateTime.current)
	@bookings.where(end: nil).update_all(:end => DateTime.current)
	@bookings.where(name: nil).update_all(:name => 'generated name')
	@bookings.where(description: nil).update_all(:description => 'generated description')
	@bookings.where(room_id: nil).update_all(:room_id => Room.first.id)
	@bookings.where(event_id: nil).update_all(:event_id => Event.first.id)
  end

end
