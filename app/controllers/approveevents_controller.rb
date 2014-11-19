class ApproveeventsController < ApplicationController
  def list
  	@events = Event.all
  	@bookings = Booking.all
  	if params[:date]
  		@currentdate = params[:date].to_date
  	else	
  	  	@currentdate = Date.today
  	end
  end
end
