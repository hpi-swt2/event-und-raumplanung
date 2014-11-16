class ApproveeventsController < ApplicationController
  def list
  	@events = Event.all
  	@bookings = Booking.all
  	@date = DateTime.now
  end
end
