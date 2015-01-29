require 'rails_helper'

RSpec.describe EventsApprovalController, :type => :controller do
 	  let(:valid_session) {  }
	  let(:task) { create :task }
	  let(:user) { create :user }
	  let(:adminUser) { create :adminUser }

	before(:all) do
		@open_event = FactoryGirl.create(:event_today, name: 'open_event')
		@approved_event = FactoryGirl.create(:approved_event, name: 'approved_event')
		@declined_event = FactoryGirl.create(:declined_event, name: 'declined_event')
		@approved_event_yesterday = FactoryGirl.create(:approved_event, name: 'approved_event_yesterday')
		@approved_event_yesterday.update_attribute(:starts_at, Date.current.yesterday.beginning_of_day)
		@approved_event_yesterday.update_attribute(:ends_at, Date.current.yesterday.end_of_day)
		@approved_event_tomorrow = FactoryGirl.create(:approved_event, name: 'approved_event_tomorrow' , starts_at: Date.current.tomorrow.beginning_of_day, ends_at: Date.current.tomorrow.end_of_day)
	end

	before(:each) do
	    @request.env["devise.mapping"] = Devise.mappings[:user]
	    sign_in adminUser
  	end

	describe "GET index as admin" do
		it "assigns all open events as @open_events" do
			get :index, {}, valid_session
			expect(assigns(:open_events)).to include(@open_event)
			expect(assigns(:open_events)).not_to include(@approved_event, @declined_event, @approved_event_yesterday, @approved_event_tomorrow)
		end
		it "assigns all approved events at specified date as @approved_events" do
			get :index, {}, valid_session
			expect(assigns(:approved_events)).to include(@approved_event)
			expect(assigns(:approved_events)).not_to include(@open_event, @declined_event, @approved_event_yesterday, @approved_event_tomorrow)
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

	describe "GET index as normal user" do
		before(:each) do
		    sign_in user
	  	end
	  	it "redirects to the root path as normal user" do
	        get :index, {}, valid_session
	        expect(response).to redirect_to(root_path)
	      end
	end

	describe "GET index as group member" do
		before(:all) do
			@group = FactoryGirl.create(:group)
			@group.permit("approve_events")
		end
		before(:each) do
		    sign_in user
		    @group.users << user
		end

	  	it "assigns all open events as @open_events" do
	  		get :index, {}, valid_session
			expect(assigns(:open_events)).to include(@open_event)
			expect(assigns(:open_events)).not_to include(@approved_event, @declined_event, @approved_event_yesterday, @approved_event_tomorrow)
		end
		it "assigns all approved events at specified date as @approved_events" do
			get :index, {}, valid_session
			expect(assigns(:approved_events)).to include(@approved_event)
			expect(assigns(:approved_events)).not_to include(@open_event, @declined_event, @approved_event_yesterday, @approved_event_tomorrow)
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

		after(:all) do 
			@group.destroy
		end
	end

	after(:all) do
		@open_event.destroy
		@approved_event.destroy
		@declined_event.destroy
		@approved_event_yesterday.destroy
		@approved_event_tomorrow.destroy
	end

end
