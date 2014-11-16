class ApproveeventsController < ApplicationController
  def list
  	@events = Event.all
  	@bookings = Booking.all
  end
end
