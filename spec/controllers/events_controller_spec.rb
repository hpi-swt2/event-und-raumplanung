require 'rails_helper'
require "cancan/matchers"

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe EventsController, :type => :controller do
  include Devise::TestHelpers

  let(:valid_session) {
  }
  let(:task) { create :task }
  let(:user) { create :user }

  let(:valid_attributes) {
    {name:'Michas GB',
    description:'Coole Sache',
    participant_count: 2000,
    starts_at_date:'2020-08-23',
    ends_at_date:'2020-08-23',
    starts_at_time:'17:00',
    ends_at_time:'23:59',
    is_private: true,
    user_id: user.id
    }
  }
 
 let(:valid_attributes_for_request) {
    {name:'Michas GB',
    description:'Coole Sache',
    participant_count: 2000,
    starts_at_date:'2020-08-23',
    ends_at_date:'2020-08-23',
    starts_at_time:'17:00',
    ends_at_time:'23:59',
    rooms: ["1", "2"], 
    is_private: true,
    user_id: user.id
    }
  }

  let(:invalid_attributes) {
    {
    name:'Michas GB',
    starts_at_date:'2014-08-23',
    ends_at_date:'2014-08-23',
    starts_at_time:'17:00',
    ends_at_time:'23:59',
    user_id: user.id
	}
  }

  let(:invalid_attributes_for_request) {
    {
    name:'Michas GB',
    starts_at_date:'2014-08-23',
    ends_at_date:'2014-08-23',
    starts_at_time:'17:00',
    ends_at_time:'23:59', 
    rooms:[],
    user_id: user.id
  }
  }

   let(:invalid_participant_count) {
    {name:'Michas GB',
   	participant_count:-100,
   	starts_at_date:'2020-08-23',
    ends_at_date:'2020-08-23',
    user_id: user.id
    }
  }

  let(:invalid_participant_count_for_request) {
    {name:'Michas GB',
    participant_count:-100,
    starts_at_date:'2020-08-23',
    ends_at_date:'2020-08-23',
    rooms: [],
    user_id: user.id
    }
  }

  let(:approved_event) { 
    { 
      name:'Michas GB',
      description:'Coole Sache',
      participant_count: 2000,
      starts_at_date:'2020-08-23',
      ends_at_date:'2020-08-23',
      starts_at_time:'17:00',
      ends_at_time:'23:59',
      room_ids: ['1'], 
    }
  }
  
  let(:event_on_multiple_days_one_room) { 
    { 
      name:'Michas GB',
      description:'Coole Sache',
      participant_count: 2000,
      starts_at_date:'2020-08-23',
      ends_at_date:'2020-08-24',
      starts_at_time:'17:00',
      ends_at_time:'23:59',
      room_ids: ['1'], 
    }
  }
  let(:event_on_multiple_days_multiple_rooms) { 
    { 
      name:'Michas GB',
      description:'Coole Sache',
      participant_count: 2000,
      starts_at_date:'2020-08-23',
      ends_at_date:'2020-08-24',
      starts_at_time:'17:00',
      ends_at_time:'23:59',
      room_ids: ['1', '2'], 
    }
  }

    let(:event_on_one_day_multiple_rooms) { 
    { 
      name:'Michas GB',
      description:'Coole Sache',
      participant_count: 2000,
      starts_at_date:'2020-08-23',
      ends_at_date:'2020-08-23',
      starts_at_time:'17:00',
      ends_at_time:'23:59',
      room_ids: ['1', '2'], 
    }
  }


  let(:not_conflicting_event) { 
    { 
      starts_at_date:'2020-08-22',
      ends_at_date:'2020-08-22',
      starts_at_time:'17:00',
      ends_at_time:'23:59',
      room_ids: ['1'], 
    }
  }

  let(:conflicting_event) { 
    { 
      starts_at_date:'2020-08-23',
      ends_at_date:'2020-08-23',
      starts_at_time:'17:00',
      ends_at_time:'23:59',
      room_ids: ['1'], 
    }
  }

  let(:not_conflicting_result) { 
    { :status => true }.to_json
  }

  let(:conflicting_result) { 
    { :status => false }.to_json
  }

  let(:room1) { 
    { 
      id: 1, 
      name: 'HS1',
    }
  }

  let(:room2) { 
    { 
      id: 2, 
      name: 'HS2',
    }
  }

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  describe "GET index" do
    it "assigns all events as @events" do
      event = Event.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:events)).to eq([event])
    end
  end

  describe "GET show" do
    it "assigns the requested event as @event" do
      event = Event.create! valid_attributes
      get :show, {:id => event.to_param}, valid_session
      expect(assigns(:event)).to eq(event)
    end

    it "assigns the tasks of the requested event as @tasks ordered by rank" do
      event = Event.create! valid_attributes
      firstTask = create(:task)
      firstTask.event = event
      firstTask.save

      secondTask = create(:task)
      secondTask.event = event
      secondTask.task_order_position = 0
      secondTask.save

      get :show, {:id => event.to_param}, valid_session
      expect(assigns(:tasks)).to eq [secondTask, firstTask]
    end
  end

  describe "GET new" do
    it "assigns a new event as @event" do
      get :new, {}, valid_session
      expect(assigns(:event)).to be_a_new(Event)
    end
  end

  describe "GET new_event_suggestion" do 
    it "stores the current event_id into the session" do 
      event = Event.create! valid_attributes
      get :new_event_suggestion, {:id => event.to_param}, valid_session
      expect(session['event_id']).to eq(event.id)
    end

    it "renders the new template of even_suggestion" do 
      event = Event.create! valid_attributes
      get :new_event_suggestion, {:id => event.to_param}, valid_session
      expect(response).to render_template("event_suggestions/new")
    end
  end

  describe "GET new_event_template" do
    it "assigns a new event_template as @event_template" do
      event = Event.create! valid_attributes
      get :new_event_template, {:id => event.to_param}, valid_session
      expect(assigns(:event_template).name).to eq event.name
      expect(assigns(:event_template).description).to eq event.description
      expect(assigns(:event_template).participant_count).to eq event.participant_count
      expect(assigns(:event_template).rooms).to eq event.rooms
      expect(response).to render_template("event_templates/new")
    end
  end

  describe "GET index_toggle_favorite" do
    it "redirects to events" do
      event = Event.create! valid_attributes
      get :index_toggle_favorite, {:id => event.to_param}, valid_session
      expect(response).to redirect_to(events_url)
    end
    
    it "toggles the favorite event" do
      event = Event.create! valid_attributes
      
      get :index_toggle_favorite, {:id => event.to_param}, valid_session
      get :index, {}, valid_session
      expect(assigns(:favorites).include?(event)).to eq true

      get :index_toggle_favorite, {:id => event.to_param}, valid_session
      get :index, {}, valid_session
      expect(assigns(:favorites).include?(event)).to eq false
      
      get :index_toggle_favorite, {:id => event.to_param}, valid_session
      get :index, {}, valid_session
      expect(assigns(:favorites).include?(event)).to eq true
    end
  end

  describe "GET show_toggle_favorite" do
    it "redirects to event" do
      event = Event.create! valid_attributes
      get :show_toggle_favorite, {:id => event.to_param}, valid_session
      expect(response).to redirect_to(event)
    end
    it "toggles the favorite event" do
      event = Event.create! valid_attributes
      get :show_toggle_favorite, {:id => event.to_param}, valid_session
      get :show, {:id => event.to_param}, valid_session
      expect(assigns(:favorite).empty?).to eq false

      get :show_toggle_favorite, {:id => event.to_param}, valid_session
      get :show, {:id => event.to_param}, valid_session
      expect(assigns(:favorite).empty?).to eq true

      get :show_toggle_favorite, {:id => event.to_param}, valid_session
      get :show, {:id => event.to_param}, valid_session
      expect(assigns(:favorite).empty?).to eq false
    end
  end

  describe "GET edit" do
    it "assigns the requested event as @event" do
      event = Event.create! valid_attributes
      get :edit, {:id => event.to_param}, valid_session
      expect(assigns(:event)).to eq(event)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Event" do
        expect {
          post :create, {:event => valid_attributes_for_request}, valid_session
        }.to change(Event, :count).by(1)
      end

      it "assigns a newly created event as @event" do
        post :create, {:event => valid_attributes_for_request}, valid_session
        expect(assigns(:event)).to be_a(Event)
        expect(assigns(:event)).to be_persisted
      end

      it "redirects to the created event" do
        post :create, {:event => valid_attributes_for_request}, valid_session
        expect(response).to redirect_to(Event.last)
      end
    end

    describe "with invalid dates" do
      it "assigns a newly created but unsaved event as @event" do
        post :create, {:event => invalid_attributes_for_request}, valid_session
        expect(assigns(:event)).to be_a_new(Event)
      end

      it "re-renders the 'new' template" do
        post :create, {:event => invalid_attributes_for_request}, valid_session
        expect(response).to render_template("new")
      end
    end

	  describe "with invalid participant count" do
      it "assigns a newly created but unsaved event as @event" do
        post :create, {:event => invalid_participant_count_for_request}, valid_session
        expect(assigns(:event)).to be_a_new(Event)
      end

      it "re-renders the 'new' template" do
        post :create, {:event => invalid_participant_count_for_request}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "POST create_even_suggestion" do
    before(:all) do 
      DatabaseCleaner.clean
      DatabaseCleaner.start 
      Room.create! name: 'HS1'
      Room.create! name: 'HS2' 
      @event = Event.create! attributes_for(:event_valid_attributes)
    end 

    describe "with valid params" do
      it "creates a new Event" do
        expect {
          get :new_event_suggestion, {:id => @event.to_param}
          post :create_event_suggestion, {:event => attributes_for(:valid_attributes_for_event_suggestion)}, valid_session
        }.to change(Event, :count).by(1)
      end  

      it "creates a new Event with the status suggested" do
        get :new_event_suggestion, {:id => @event.to_param}
        post :create_event_suggestion, {:event => attributes_for(:valid_attributes_for_event_suggestion)}, valid_session
        expect(assigns(:event)[:status]).to eq('suggested')
      end

      it "creates a new Event with the name, description, participant_count, importance and privacy of the old event" do
        get :new_event_suggestion, {:id => @event.to_param}
        post :create_event_suggestion, {:event => attributes_for(:valid_attributes_for_event_suggestion)}, valid_session
        expect(assigns(:event)['name']).to eq(@event.name)
        expect(assigns(:event)['description']).to eq(@event.description)
        expect(assigns(:event)['participant_count']).to eq(@event.participant_count)
        expect(assigns(:event)['is_important']).to eq(@event.is_important)
        expect(assigns(:event)['is_private']).to eq(@event.is_private)
      end

      it "assigns a newly created Event as @event" do
        get :new_event_suggestion, {:id => @event.to_param}
        post :create_event_suggestion, {:event => attributes_for(:valid_attributes_for_event_suggestion)}, valid_session
        expect(assigns(:event)).to be_a(Event)
        expect(assigns(:event)).to be_persisted
      end

      it "redirects to the created event_suggestion" do
        get :new_event_suggestion, {:id => @event.to_param}
        post :create_event_suggestion, {:event => attributes_for(:valid_attributes_for_event_suggestion)}, valid_session
        expect(response).to redirect_to(Event.last)
      end
    end
    
    describe "with invalid params" do
      it "assigns a newly created but unsaved Event as @event" do
        get :new_event_suggestion, {:id => @event.to_param}
        post :create_event_suggestion, {:event => attributes_for(:event_invalid_attributes)}, valid_session
        expect(assigns(:event)).to be_a_new(Event)
      end

      it "original event_id is still saved in session" do 
        get :new_event_suggestion, {:id => @event.to_param}
        post :create_event_suggestion, {:event => attributes_for(:event_invalid_attributes)}, valid_session
        expect(session[:event_id]).to eq(@event.id)
      end  
     
      it "re-renders the 'new' template" do
        get :new_event_suggestion, {:id => @event.to_param}
        post :create_event_suggestion, {:event => attributes_for(:event_invalid_attributes)}, valid_session        
        expect(response).to render_template("event_suggestions/new")
      end
    end

    after(:all) do 
      DatabaseCleaner.clean
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        {name:'Michas GB 2',
        description:'Keine coole Sache',
        participant_count: 1,
        rooms: []
        }
      }

      it "updates the requested event" do
        event = Event.create! valid_attributes
        put :update, {:id => event.to_param, :event => new_attributes}, valid_session
        event.reload
        #expect(event.name).to eq 'Michas GB 2'
        #expect(event.description).to eq 'Keine coole Sache'
        #expect(event.participant_count).to be 1

      end

      it "assigns the requested event as @event" do
        event = Event.create! valid_attributes
        put :update, {:id => event.to_param, :event => valid_attributes_for_request}, valid_session
        expect(assigns(:event)).to eq(event)
      end

      it "redirects to the event" do
        event = Event.create! valid_attributes
        put :update, {:id => event.to_param, :event => valid_attributes_for_request}, valid_session
        expect(response).to redirect_to(event)
      end
    end

    describe "with invalid params" do
      it "assigns the event as @event" do
        event = Event.create! valid_attributes
        put :update, {:id => event.to_param, :event => invalid_attributes_for_request}, valid_session
        expect(assigns(:event)).to eq(event)
      end

      it "re-renders the 'edit' template" do
        event = Event.create! valid_attributes
        put :update, {:id => event.to_param, :event => invalid_attributes_for_request}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "GET new_event_suggestion" do 
    it "creates a new event suggestion and assigns it as @event_suggestion" do 
      event = Event.create! valid_attributes
      get :new_event_suggestion, {:id => event.to_param}, valid_session
      event_suggestion = assigns(:event)
      expect(event_suggestion.starts_at).to eq(event.starts_at)
      expect(event_suggestion.ends_at).to eq(event.ends_at)
      expect(event_suggestion.rooms).to eq(event.rooms)
      expect(event_suggestion.user_id).to eq(event.user_id)
      expect(session['event_id']).to eq(event.id)
    end 
    
    it "renders the event_suggestion 'new' template" do 
      event = Event.create! valid_attributes
      get :new_event_suggestion, {:id => event.to_param}, valid_session
      expect(response).to render_template("event_suggestions/new")
    end
  end 

  describe "GET approve" do 
    it "approves the given event" do
      event = Event.create! valid_attributes
      get :approve, {:id => event.to_param}
      expect(assigns(:event).status).to eq('approved')
    end

    it "redirects to events_approval_path" do
      event = Event.create! valid_attributes
      get :approve, {:id => event.to_param}, valid_session
      expect(response).to redirect_to(events_approval_path)
    end
  end

  describe "GET approve_event_suggestion" do 
    it "approves the given event suggestion" do 
      event_suggestion = Event.create! valid_attributes
      get :new_event_suggestion, {:id => event_suggestion.to_param}
      post :create_event_suggestion, {:event => attributes_for(:valid_attributes_for_event_suggestion)}, valid_session
      get :approve_event_suggestion, {:id => event_suggestion.to_param}
      expect(assigns(:event).status).to eq('pending')
    end

    it "redirects to events_path" do
      event_suggestion = Event.create! valid_attributes
      get :new_event_suggestion, {:id => event_suggestion.to_param}
      post :create_event_suggestion, {:event => attributes_for(:valid_attributes_for_event_suggestion)}, valid_session
      get :approve_event_suggestion, {:id => event_suggestion.to_param}
      expect(response).to redirect_to(events_path)
    end
  end

  describe "GET decline_event_suggestion" do 
    it "approves the given event suggestion" do 
      event_suggestion = Event.create! valid_attributes
      get :new_event_suggestion, {:id => event_suggestion.to_param}
      post :create_event_suggestion, {:event => attributes_for(:valid_attributes_for_event_suggestion)}, valid_session
      get :decline_event_suggestion, {:id => event_suggestion.to_param}
      expect(assigns(:event).status).to eq('declined')
    end

    it "redirects to events_path" do
      event_suggestion = Event.create! valid_attributes
      get :new_event_suggestion, {:id => event_suggestion.to_param}
      post :create_event_suggestion, {:event => attributes_for(:valid_attributes_for_event_suggestion)}, valid_session
      get :decline_event_suggestion, {:id => event_suggestion.to_param}
      expect(response).to redirect_to(events_path)
    end
  end

  describe "GET decline" do 
    it "declines the given event" do
      event = Event.create! valid_attributes
      get :decline, {:id => event.to_param, :event => invalid_attributes_for_request}, valid_session
      expect(assigns(:event).status).to eq('declined')
    end

    it "redirects to events_decline_path" do
      event = Event.create! valid_attributes
      get :decline, {:id => event.to_param, :event => invalid_attributes_for_request}, valid_session
      expect(response).to redirect_to(events_approval_path)
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested event" do
      event = Event.create! valid_attributes
      expect {
        delete :destroy, {:id => event.to_param}, valid_session
      }.to change(Event, :count).by(-1)
    end

    it "redirects to the events list" do
      event = Event.create! valid_attributes
      delete :destroy, {:id => event.to_param}, valid_session
      expect(response).to redirect_to(events_url)
    end
  end

  describe "If conflicting events" do 
    before(:all) do
      DatabaseCleaner.clean
      DatabaseCleaner.start 
      Room.create! name: 'HS1'
      Room.create! name: 'HS2'
      Event.create! attributes_for(:scheduledEvent)
    end

    after(:all) do 
      DatabaseCleaner.clean
    end 

    describe "do not exist" do 
      it "then no conflicting events are returned" do 
        patch :check_vacancy, event: not_conflicting_event, format: :json
        result = JSON.parse(response.body)
        expect(result).to include('status')
        expect(result['status']).to eq(true)
        expect(response.body).to eq(not_conflicting_result) 
      end
    end
    describe "do exist" do
      it "then conflicting events are returned" do 
        patch :check_vacancy, event: conflicting_event, format: :json
        result = JSON.parse(response.body)
        expect(result).to include('status')
        expect(result['status']).to eq(false)     
      end 

      it "then all conflicting events are returned" do 
        patch :check_vacancy, event: conflicting_event, format: :json
        result = JSON.parse(response.body)
        expect(result.length).to eq(2)
      end

      describe "and if the conflicting event" do 
        it "takes place on one day in one room, the correct error message gets returned" do 
          event = Event.create! attributes_for(:event_on_one_day_with_one_room)
          start_time = I18n.l event.starts_at, format: :time_only
          end_time = I18n.l event.ends_at, format: :time_only
          patch :check_vacancy, event: conflicting_event, format: :json
          result = JSON.parse(response.body)
          expect(result[event.id.to_s]).to include('msg')
          expect(result[event.id.to_s]['msg']).to eq(I18n.t('event.alert.conflict_same_days_one_room', name: event.name, start_date: event.starts_at.strftime("%d.%m.%Y"), start_time: start_time, end_time: end_time, rooms: event.rooms.pluck(:name).to_sentence))
        end

        it "takes place on multiple days in one room, the correct error message gets returned" do 
          event = Event.create! attributes_for(:event_on_multiple_days_with_one_room)
          start_time = I18n.l event.starts_at, format: :time_only
          end_time = I18n.l event.ends_at, format: :time_only
          patch :check_vacancy, event: conflicting_event, format: :json
          result = JSON.parse(response.body)
          expect(result[event.id.to_s]).to include('msg')
          expect(result[event.id.to_s]['msg']).to eq(I18n.t('event.alert.conflict_different_days_one_room', name: event.name, start_date: event.starts_at.strftime("%d.%m.%Y"), end_date: event.ends_at.strftime("%d.%m.%Y"), start_time: start_time, end_time: end_time, rooms: event.rooms.pluck(:name).to_sentence))
        end
        it "takes place on multiple days in mulitple rooms, the correct error message gets returned" do 
          event = Event.create! attributes_for(:event_on_multiple_days_with_multiple_rooms)
          start_time = I18n.l event.starts_at, format: :time_only
          end_time = I18n.l event.ends_at, format: :time_only
          patch :check_vacancy, event: conflicting_event, format: :json
          result = JSON.parse(response.body)
          expect(result[event.id.to_s]).to include('msg')
          expect(result[event.id.to_s]['msg']).to eq(I18n.t('event.alert.conflict_different_days_multiple_rooms', name: event.name, start_date: event.starts_at.strftime("%d.%m.%Y"), end_date: event.ends_at.strftime("%d.%m.%Y"), start_time: start_time, end_time: end_time, rooms: event.rooms.pluck(:name).to_sentence))
        end
        
        it "takes place on one day in multiple rooms, the correct error message gets returned" do 
          event = Event.create! attributes_for(:event_on_one_day_with_multiple_rooms)
          start_time = I18n.l event.starts_at, format: :time_only
          end_time = I18n.l event.ends_at, format: :time_only
          patch :check_vacancy, event: conflicting_event, format: :json
          result = JSON.parse(response.body)
          expect(result[event.id.to_s]).to include('msg')
          expect(result[event.id.to_s]['msg']).to eq(I18n.t('event.alert.conflict_same_days_multiple_rooms', name: event.name, start_date: event.starts_at.strftime("%d.%m.%Y"), end_date: event.ends_at.strftime("%d.%m.%Y"), start_time: start_time, end_time: end_time, rooms: event.rooms.pluck(:name).to_sentence))
        end
      end
    end
  end
end
