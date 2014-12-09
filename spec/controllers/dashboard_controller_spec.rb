require 'rails_helper'
require 'cancan/matchers'
require 'timecop'

RSpec.describe DashboardController, type: :controller do
  include Devise::TestHelpers

  let(:valid_session) { }
  let(:user) { create :user }

  let(:valid_attributes) {{
    name:'Michas GB',
    description:'Coole Sache',
    participant_count: 2000,
    starts_at_date:'2020-08-23',
    ends_at_date:'2020-08-23',
    starts_at_time:'17:00',
    ends_at_time:'23:59',
    is_private: true,
    user_id: user.id
  }}

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  describe "GET index" do
    it "assigns upcoming event to @events" do
      event = Event.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:events)).to eq([event])
    end

    it "assigns max 5 upcoming events as @events" do
      6.times { |i| FactoryGirl.create(:upcoming_event, name: i.to_s) }
      get :index, {}, valid_session
      expect(assigns(:events).size).to eq(5)
    end
  
    describe "My tasks partial" do
      let!(:event) { create :event, user_id: user.id, starts_at: Date.today + 5, ends_at: Date.today + 6 }
      let!(:other_user) { create :user }
      let!(:task) { create :assigned_task, event_id: event.id, user_id: user.id, status: 'accepted' }
      let!(:other_task) { create :assigned_task, name: 'Other Task', event_id: event.id, user_id: other_user.id }
      let!(:pending_task) { create :assigned_task, name: 'Pending Task', event_id: event.id, user_id: user.id }
      let!(:past_event) { create :event, name: 'Past Event', user_id: user.id }
      let!(:past_task) { create :assigned_task, name: 'Past Task', event_id: past_event.id, user_id: user.id, status: 'accepted' }

      before do
        Timecop.freeze(Date.today + 3)
      end

      after do
        Timecop.return
      end


      it 'assigns only accepted tasks for the currently logged in user to @my_accepted_tasks' do
        get :index, {}, valid_session
        expect(assigns(:my_accepted_tasks).include? task).to eq(true)
        expect(assigns(:my_accepted_tasks).include? other_task).to eq(false)
        expect(assigns(:my_accepted_tasks).include? pending_task).to eq(false)
        expect(assigns(:my_accepted_tasks).include? past_task).to eq(false)
      end

      it 'assigns only pending tasks for the currently logged to @my_pending_tasks' do
        get :index, {}, valid_session
        expect(assigns(:my_pending_tasks).include? task).to eq(false)
        expect(assigns(:my_pending_tasks).include? other_task).to eq(false)
        expect(assigns(:my_pending_tasks).include? pending_task).to eq(true)
        expect(assigns(:my_pending_tasks).include? past_task).to eq(false)
      end

      it 'assigns only events that are in the future and have accepted tasks for the currently logged in user to @my_accepted_events' do
        get :index, {}, valid_session
        expect(assigns(:my_accepted_events).include? event). to eq(true)
        expect(assigns(:my_accepted_events).include? past_event). to eq(false)        
      end

      it 'assigns only events that are in the future and have pending tasks for the currently logged in user to @my_pending_events' do
        get :index, {}, valid_session
        expect(assigns(:my_pending_events).include? event). to eq(true)
        expect(assigns(:my_pending_events).include? past_event). to eq(false)        
      end
    end
  end
end