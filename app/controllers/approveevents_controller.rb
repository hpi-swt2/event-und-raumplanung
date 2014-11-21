class ApproveeventsController < ApplicationController

	before_action :read_and_exec_params
	def read_and_exec_params
		if params[:date]
			@date = params[:date].to_date
		else	
			@date = Date.today
		end
	end

  def list
  		@bookings = Booking.all
  		@events = Event.all
  		check_data # data must be checked before selection criterea as events links to bookings which are filtered out
  		@events.where!(approved: nil)
  		@bookings.where!('start BETWEEN ? AND ?', @date.beginning_of_day, @date.end_of_day).order(:start, :event_id)
  end

  def check_data # the validation of the data should move to the controller in the future
  	@events.where(name: nil).update_all(:name => '')
  	@events.where(description: nil).update_all(:description => '')
  	@events.where(start_time: nil).update_all(:start_time => Time.new)
  	@events.where(end_time: nil).update_all(:end_time => Time.new)
   	@events.where(start_date: nil).update_all(:start_date => Date.new)
  	@events.where(end_date: nil).update_all(:end_date => Date.new)

  	@bookings.where(start: nil).update_all(:start => DateTime.new)
	@bookings.where(end: nil).update_all(:end => DateTime.new)
	@bookings.where(name: nil).update_all(:name => '')
	@bookings.where(description: nil).update_all(:description => '')
	@bookings.where(room_id: nil).update_all(:room_id => Room.first.id)
	@bookings.where(event_id: nil).update_all(:event_id => Event.first.id)
  end

end
