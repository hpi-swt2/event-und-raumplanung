require 'rails_helper'

RSpec.describe Booking, :type => :model do

	before(:all) do
		@open_event = FactoryGirl.create(:event, name: 'open_event')
		@approved_event = FactoryGirl.create(:approved_event, name: 'approved_event')
		@declined_event = FactoryGirl.create(:declined_event, name: 'declined_event')
  	@approved_booking = FactoryGirl.create(:booking_today, name: 'approved_booking', event: @approved_event)
	  @open_booking = FactoryGirl.create(:booking_today, name: 'open_booking', event: @open_event)
	  @declined_booking = FactoryGirl.create(:booking_today, name: 'declined_booking', event: @declined_event)
	  @booking_yesterday = FactoryGirl.create(:booking_yesterday, name: 'booking_yesterday', event: @open_event)
	  @booking_today = FactoryGirl.create(:booking_today, name: 'booking_today', event: @open_event)
	  @booking_tomorrow = FactoryGirl.create(:booking_tomorrow, name: 'booking_tomorrow', event: @open_event)
	end

  it ".approved should only return bookings with approved events" do
  	results = Booking.approved
	  expect(results).to include(@approved_booking)
	  expect(results).not_to include(@open_booking, @declined_booking)
  end

  it ".start_at_day should only return bookings which start at the specified day" do
  	results = Booking.start_at_day(Date.current)
	  expect(results).to include(@booking_today)
	  expect(results).not_to include(@booking_yesterday, @booking_tomorrow)
  end

  after(:all) do
		@open_event.destroy
		@approved_event.destroy
		@declined_event.destroy
  	@approved_booking.destroy
	  @open_booking.destroy
	  @declined_booking.destroy
	  @booking_yesterday.destroy
	  @booking_today.destroy
	  @booking_tomorrow.destroy
	end
end
