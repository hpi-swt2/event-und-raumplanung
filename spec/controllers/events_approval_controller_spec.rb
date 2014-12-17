require 'rails_helper'

RSpec.describe EventsApprovalController, :type => :controller do
 	  let(:valid_session) {  }
	  let(:task) { create :task }
	  let(:user) { create :user }

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

	before(:each) do
	    @request.env["devise.mapping"] = Devise.mappings[:user]
	    sign_in user
  	end

	describe "GET index" do
		it "assigns all open events as @events" do
			get :index, {}, valid_session
			expect(assigns(:events)).to include(@open_event)
			expect(assigns(:events)).not_to include(@approved_event, @declined_event)
		end
		it "assigns all approved bookings at specified date as @bookings" do
			get :index, {}, valid_session
			expect(assigns(:bookings)).to include(@approved_booking)
			expect(assigns(:bookings)).not_to include(@open_bookings, @declined_bookings, @booking_yesterday, @booking_today, @booking_tomorrow)
		end
		it "assigns simple date parameter correctly as @date" do
			date = Date.current.yesterday
			get :index, {:date => date}, valid_session
			expect(assigns(:date)).to eq(date)
		end
		it "assigns date hash parameter correctly as @date" do
			hash_date = {:day => 5, :month => 10, :year => 2014}
			get :index, {:date => hash_date}, valid_session
			expect(assigns(:date)).to eq(Date.new(2014, 10, 5))
		end
		it "assigns current date if a hashparameter is missing as @date" do
			hash_date = {:month => 10, :year => 2014}
			get :index, {:date => hash_date}, valid_session
			expect(assigns(:date)).to eq(Date.current)
		end
		it "assigns current date if correct date parameter does not exist @date" do
			get :index, {:dates => Date.current.yesterday}, valid_session
			expect(assigns(:date)).to eq(Date.current)
		end
		it "assigns current date if requested date does not exist @date" do
			get :index, {:date => 2013-11-31}, valid_session
			expect(assigns(:date)).to eq(Date.current)
		end

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
