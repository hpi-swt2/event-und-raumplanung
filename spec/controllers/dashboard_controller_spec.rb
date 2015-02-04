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
    user_id: user.id,
    rooms: [FactoryGirl.build(:room)]
  }}

  let(:event) { create :event, user_id: user.id, starts_at: Date.today + 5, ends_at: Date.today + 6 }
  let(:other_event) { create :event, user_id: user.id, starts_at: Date.today + 5, ends_at: Date.today + 6 }
  let(:other_user) { create :user }
  let(:past_event) { create :event, name: 'Past Event', user_id: user.id }
  let(:group) { create :group, users: [user] }

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  describe "GET index" do
    it "assigns upcoming event to @events" do
      event = Event.create! valid_attributes
      get :index, {}, valid_session
      event_occurrence = EventOccurrence.new({ event: event, starts_occurring_at: event.starts_at, ends_occurring_at: event.ends_at })
      expect(assigns(:event_occurrences).to_s).to eq([event_occurrence].to_s)
    end

    it "assigns max 5 upcoming events as @events" do
      6.times { |i| FactoryGirl.create(:upcoming_event, name: i.to_s, user_id: user.id) }
      get :index, {}, valid_session
      expect(assigns(:event_occurrences).size).to eq(5)
    end
  
    describe "My tasks partial" do
      let!(:task) { create :assigned_task, event_id: event.id, identity: user, status: 'accepted' }
      let!(:other_task) { create :assigned_task, name: 'Other Task', event_id: event.id, identity: other_user }
      let!(:pending_task) { create :assigned_task, name: 'Pending Task', event_id: event.id, identity: user }
      let!(:past_task) { create :assigned_task, name: 'Past Task', event_id: past_event.id, identity: user, status: 'accepted' }
      let!(:another_group) { create :group }
      let!(:group_task) { create :assigned_task, event_id: event.id, identity: group}
      let!(:task_done) { create :assigned_task, event_id: event.id, identity: user, done: true}

      before do
        Timecop.freeze(Date.today + 3)
      end

      after do
        Timecop.return
      end

      it 'assigns only accepted tasks for the currently logged in user that have not been done yet to @my_accepted_tasks' do
        get :index, {}, valid_session
        expect(assigns(:my_accepted_tasks).include? task).to eq(true)
        expect(assigns(:my_accepted_tasks).include? other_task).to eq(false)
        expect(assigns(:my_accepted_tasks).include? pending_task).to eq(false)
        expect(assigns(:my_accepted_tasks).include? past_task).to eq(false)
        expect(assigns(:my_accepted_tasks).include? task_done).to eq(false)
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

      it 'assigns only groups I am in to @my_groups' do
        get :index, {}, valid_session
        expect(assigns(:my_groups).include? group). to eq(true)
        expect(assigns(:my_groups).include? another_group). to eq(false)
        expect(assigns(:my_groups).first.users.include? user). to eq(true)
      end

      it 'assigns only the group task to @group_pending_tasks' do
        get :index, {}, valid_session
        expect(assigns(:group_pending_tasks).include? group_task). to eq(true)
        expect(assigns(:group_pending_tasks).include? task). to eq(false)
      end

      it 'assigns only the event with group in which I am and have tasks to @group_pending_events' do
        get :index, {}, valid_session
        expect(assigns(:group_pending_events).include? event). to eq(true)
        expect(assigns(:group_pending_events).include? other_event). to eq(false)
      end
      
    end

    describe "My events widget on Dashboard" do
      let(:other_user_event) { create :event, user_id: other_user.id, starts_at: Date.today + 5, ends_at: Date.today + 6 }

      it 'assigns max 5 upcoming events as @my_upcoming_events' do
        6.times { |i| FactoryGirl.create(:my_upcoming_event, name: i.to_s, user_id: user.id) }
        get :index, {}, valid_session
        expect(assigns(:my_upcoming_events).size).to eq(5)
      end

      it 'should only assign upcoming events' do
        get :index, {}, valid_session
        expect(assigns(:my_upcoming_events).include? event). to eq(true)
        expect(assigns(:my_upcoming_events).include? past_event). to eq(false)
      end

      it 'should only assign my events' do
        get :index, {}, valid_session
        expect(assigns(:my_upcoming_events).include? event). to eq(true)
        expect(assigns(:my_upcoming_events).include? other_user_event). to eq(false)
      end
    end

    describe "GET events_between" do
      it "gets a json with calender events" do
        2.times { |i| FactoryGirl.create(:upcoming_event, name: i.to_s, user_id: user.id) }
        get :events_between, {start: Time.now.to_s, :end => Time.now.advance(days: 2).to_s}
        json = JSON.parse(response.body)
        expect(json.size).to eq(2)
      end

      it "raises an error if no start and en params are set" do
        expect {
          get :events_between, format: :json
        }.to raise_error(ActionController::ParameterMissing)
      end
    end
  end
end
