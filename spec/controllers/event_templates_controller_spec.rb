require 'rails_helper'
require "cancan/matchers"

RSpec.describe EventTemplatesController, :type => :controller do
  include Devise::TestHelpers

  let(:task) { create :task }
  let(:user) { create :user }

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  let(:valid_attributes) {
    {name:'Michas GB',
    description:'Coole Sache',
    user_id: user.id,
    participant_count: 1
    }
  }

  let(:valid_attributes_with_event_id) {
    {name:'Michas GB',
    description:'Coole Sache',
    user_id: user.id,
    participant_count: 1, 
    event_id: 1
    }
  }

  describe "GET index" do
    it "assigns all event_templates as @event_templates" do
      event_template = FactoryGirl.create(:event_template)
      get :index
      expect(assigns(:event_templates)).to eq([event_template])
    end
  end

  describe "GET show" do
    it "assigns the requested event_template as @event_template" do
      event_template = FactoryGirl.create(:event_template)
      get :show, {:id => event_template.to_param}
      expect(assigns(:event_template)).to eq(event_template)
    end

    it "assigns the tasks of the requested event_template as @tasks ordered by rank" do
      event_template = EventTemplate.create! valid_attributes
      firstTask = create(:task)
      firstTask.event_template = event_template
      firstTask.save

      secondTask = create(:task)
      secondTask.event_template = event_template
      secondTask.task_order_position = 0
      secondTask.save

      get :show, {:id => event_template.to_param}
      expect(assigns(:tasks)).to eq [secondTask, firstTask]
    end
  end

  describe "GET new" do
    it "assigns a new event_template as @event_template" do
      get :new, {}
      expect(assigns(:event_template)).to be_a_new(EventTemplate)
    end
  end

  describe "GET new_event" do
    it "assigns a new event as @event" do
      event_template = FactoryGirl.create(:event_template)
      get :new_event, {:id => event_template.to_param}
      expect(assigns(:event).name).to eq event_template.name
      expect(assigns(:event).description).to eq event_template.description
      expect(response).to render_template("events/new")
    end

    it "assigns the event_template id as @event_template_id" do 
      event_template = FactoryGirl.create(:event_template)
      get :new_event, {:id => event_template.to_param}
      expect(assigns(:event_template_id)).to eq event_template.id
    end
  end

  describe "GET edit" do
    it "assigns the requested event_template as @event_template" do
      event_template = FactoryGirl.create(:event_template)
      get :edit, {:id => event_template.to_param}
      expect(assigns(:event_template)).to eq(event_template)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new EventTemplate" do
        expect {
          post :create, {:event_template => valid_attributes}
          }.to change(EventTemplate, :count).by(1)
      end

      it "assigns a newly created event_template as @event_template" do
        post :create, {:event_template => valid_attributes}
        expect(assigns(:event_template)).to be_a(EventTemplate)
        expect(assigns(:event_template)).to be_persisted
      end

      it "redirects to the created event_template" do
        post :create, {:event_template => valid_attributes}
        expect(response).to redirect_to(EventTemplate.last)
      end
    end

    describe "and prior event" do
      before(:all) do 
        DatabaseCleaner.clean
        DatabaseCleaner.start
        FactoryGirl.create(:event)
      end   
      
      it "assigns @event_id with the id of the prior event" do
        post :create, {:event_template => valid_attributes_with_event_id}
        expect(assigns(:event_id).to_i).to eq(valid_attributes_with_event_id[:event_id])
      end

      it "creates a new Event Template" do
        expect {
          post :create, {:event_template => valid_attributes_with_event_id}
        }.to change(EventTemplate, :count).by(1)
      end
      
      describe "without tasks" do
        it "then no new tasks are created" do
          expect {
            post :create, {:event_template => valid_attributes_with_event_id}
          }.to_not change(Task, :count)
        end
        
        it "then new event has no tasks" do
          post :create, {:event_template => valid_attributes_with_event_id}
          expect(assigns(:event_template).tasks).to be_empty
        end 
      end

      describe "with tasks" do
        before(:all) do
          DatabaseCleaner.clean
          FactoryGirl.create(:event, :with_assignments)
        end

        it "then new tasks are created" do
          event = Event.find(valid_attributes_with_event_id[:event_id]) 
          expect {
            post :create, {:event_template => valid_attributes_with_event_id}
          }.to change(Task, :count).by(event.tasks.length)
        end

        it "then event_templates tasks have the same values as events tasks" do
          post :create, {:event_template => valid_attributes_with_event_id}
          event = Event.find(valid_attributes_with_event_id[:event_id]) 
          ignored = ['id', 'updated_at', 'created_at', 'event_template_id', 'event_id', 'done', 'identity_id', 'identity_type', 'creator_id', 'status']
          assigns(:event_template).tasks.each_with_index do |task, i|
            expect(task.attributes.except(*ignored)).to eql(event.tasks[i].attributes.except(*ignored))
          end
        end
        
        it "then event_template_id tasks attributes user_id, done, deadline, status and event_id are not assigned" do
          post :create, {:event_template => valid_attributes_with_event_id}
          assigns(:event_template).tasks.each do |task|
            expect(task).to have_attributes(:identity_id => nil)
            expect(task).to have_attributes(:status => nil)
            expect(task).to have_attributes(:done => false)
            expect(task).to have_attributes(:event_id => nil)
          end
        end
        describe "that have attachments" do 
          before(:all) do
            DatabaseCleaner.clean
            FactoryGirl.create(:event, :with_assignments_that_have_attachments)
          end

          it "then new attachments are created" do
            event = Event.find(valid_attributes_with_event_id[:event_id]) 
            attachment_count = event.tasks.inject(0) { |result, task| result + task.attachments.length}
            expect {
              post :create, {:event_template => valid_attributes_with_event_id}
            }.to change(Attachment, :count).by(attachment_count)
          end
         
          it "then the newly created attachments have the same values as the events tasks attachments" do
            post :create, {:event_template => valid_attributes_with_event_id}
            event = Event.find(valid_attributes_with_event_id[:event_id]) 
            ignored = ['id', 'updated_at', 'created_at', 'task_id']
            assigns(:event_template).tasks.each_with_index do |task, i|
                task.attachments.each_with_index do |attachment, j| 
                expect(attachment.attributes.except(*ignored)).to eql(event.tasks[i].attachments[j].attributes.except(*ignored))
              end
            end
          end
        end
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
        participant_count: 1
        }
      }

      it "updates the requested event" do
        event = EventTemplate.create! valid_attributes
        put :update, {:id => event.to_param, :event_template => new_attributes}
        event.reload
        expect(event.name).to eq 'Michas GB 2'
        expect(event.description).to eq 'Keine coole Sache'
        expect(event.participant_count).to be 1
      end

      it "assigns the requested event as @event" do
        event = EventTemplate.create! valid_attributes
        put :update, {:id => event.to_param, :event_template => valid_attributes}
        expect(assigns(:event_template)).to eq(event)
      end

      it "redirects to the event" do
        event = EventTemplate.create! valid_attributes
        put :update, {:id => event.to_param, :event_template => valid_attributes}
        expect(response).to redirect_to(event)
      end
    end
  end
  
 describe "DELETE destroy" do
    it "destroys the requested event" do
      event = EventTemplate.create! valid_attributes
      expect {
        delete :destroy, {:id => event.to_param}
      }.to change(EventTemplate, :count).by(-1)
    end

    it "redirects to the events list" do
      event = EventTemplate.create! valid_attributes
      delete :destroy, {:id => event.to_param}
      expect(response).to redirect_to(event_templates_url)
    end
  end
end
