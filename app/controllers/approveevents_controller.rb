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
		@events = Event.where(approved: nil)
		@bookings = Booking.where('start BETWEEN ? AND ?', @date.beginning_of_day,
			@date.end_of_day).order(:start, :event_id)
		check_data
  end

  def check_data
		@events.each do |event|
			if event.name.nil?
				event.name = 'name'
			end
			if event.description.nil?
				event.description = 'description'
			end
			if event.start_date.nil?
				event.start_date = Date.today
			end
			if event.end_date.nil?
				event.end_date = Date.today
			end
			if event.start_time.nil?
				event.start_time = Time.current
			end
			if event.end_time.nil?
				event.end_time = Time.current
			end
			if event.user.nil?
				event.user = User.first
			end
		end

		@bookings.each do |booking|
			if @bookings.find(booking).name.nil?
				@bookings.find(booking).name = 'name'
			end
			if @bookings.find(booking).description.nil?
				@bookings.find(booking).description = 'description'
			end
			if @bookings.find(booking).start.nil?
				@bookings.find(booking).start = DateTime.current
			end
			if @bookings.find(booking).end.nil?
				@bookings.find(booking).end = DateTime.current
			end
			if @bookings.find(booking).room.nil?
				@bookings.find(booking).room = Room.create(name: 'Raum')
			end
			if @bookings.find(booking).event.nil?
				@bookings.find(booking).event = Event.first
			end
		end
  end

end
