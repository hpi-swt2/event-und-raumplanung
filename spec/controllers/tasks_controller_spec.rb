require 'rails_helper'


RSpec.describe TasksController, type: :controller do
    let(:event) { FactoryGirl.create :event }
    let(:user) { FactoryGirl.create :user }
    let(:task) { FactoryGirl.create :task }
    let(:anotherUser) { FactoryGirl.create :user }
    let(:assigned_task) { FactoryGirl.create :assigned_task, event_id: event.id, user_id: user.id }
    let(:unassigned_task) { FactoryGirl.create :unassigned_task, event_id: event.id }
    let(:valid_attributes) {
      {
        name: "Test",
        done: false,
        description: "description"
      }
    }

    let(:valid_attributes_for_task_update) {
      {
        name: "Test",
        done: false,
        description: "new description"
      }
    }

    let(:valid_attributes_with_user) {
      {
        name: "Test",
        done: false,
        description: "description",
        user_id: user.id
      }
    }

    let(:valid_attributes_with_event_template_id) {
        {
        name: "Test",
        description: "description",
        event_template_id: 1
      }
    } 

    let(:valid_attributes_with_event_id) {
        {
        name: "Test",
        description: "description",
        event_id: 1
      }
    } 

    let(:valid_attributes_with_attachement) { 
      {
        name: "Test",
        description: "description",
        event_id: 1,
        attachments_attributes: [ { title: "Example", url: "http://example.com"} ]
      }
    }

    let(:invalid_attributes) {
      {
        name: '',
      }
    }

  let(:valid_session) { {} }
  
  describe "GET accept" do  
    before(:each) { sign_in user }

    it 'should change tasks status of assigned task to accepted' do
      expect{get :accept, id: assigned_task.id}.to change{Task.find(assigned_task.id).status}.from("pending").to("accepted")
    end

    it 'should not change tasks status of unassigned task to accepted' do
      expect{get :accept, id: unassigned_task.id}.to_not change{Task.find(unassigned_task.id).status}
    end
  end

  describe "GET decline" do
    before(:each) do
      sign_in user
    end 

    it 'should change tasks status of assigned task to declined' do
      expect{
        get :decline, id: assigned_task.id
      }.to change{Task.find(assigned_task.id).status}.from("pending").to("declined")
    end

    it 'should not change tasks status of unassigned task to declined' do
      expect{
        get :decline, id: unassigned_task.id
      }.to_not change{Task.find(unassigned_task.id).status}
    end
  end

  describe "When user is not logged-in" do
    it "redirects unauthenticated calls to login page" do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end
  end
  
  describe "The user is logged-in. " do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
      ActionMailer::Base.deliveries.clear
    end
  
    describe "GET index" do 
      it "renders the index template" do
        get :index
        expect(response).to render_template("index")
      end
  
      it "loads the events in order to filter tasks" do
        get :index
        expect(assigns(:events)).not_to be_nil
      end
    end 
  
    describe "GET new" do
      before(:all) do 
        DatabaseCleaner.clean 
        DatabaseCleaner.start
      end

      it "renders the new template" do 
        get :new
        expect(response).to render_template("new")
      end

      it "sets the event for @task that should belong to the event" do
        get :new, { event_id: 1 }
        expect(assigns(:task).event_id).to eq(1)
      end

      it "sets the event_template for @task that should belong to the event_template" do
        get :new, { event_template_id: 1 }
        expect(assigns(:task).event_template_id).to eq(1)
      end

      it "sets @for_event_template to true if task for an EventTemplate should be created" do 
        event_template = FactoryGirl.create :event_template
        get :new, {:event_template_id => event_template.to_param}
        expect(assigns(:for_event_template)).to eq(true)
      end 

      it "sets @for_event_template to false if task for an Event should be created" do 
        event = FactoryGirl.create :event
        get :new, {:event_id => event.to_param}
        expect(assigns(:for_event_template)).to eq(false)
      end

      after(:all) do 
        DatabaseCleaner.clean
      end 
    end

    describe "POST create" do 
      before(:all) do 
        FactoryGirl.create :room1
        @event = FactoryGirl.create :scheduledEvent
      end 

      describe "with valid params" do
    

        it "creates task" do
          params = valid_attributes
          params['event_id'] = @event.id
          expect { 
            post :create, { task: params }
          }.to change(Task, :count).by(1)
        end 
        
        it "assigns a newly created event as @event" do
          params = valid_attributes
          params['event_id'] = @event.id
          post :create, { task: params }
          expect(assigns(:task)).to be_a(Task)
          expect(assigns(:task)).to be_persisted
        end 

        it "redirects to the created tasks event" do
          params = valid_attributes
          params['event_id'] = @event.id
          post :create, { task: params }
          expect(response).to redirect_to(Task.last.event)
        end

        it "creates task that are marked as undone" do
          post :create, task: { description: "description", name: "Test", done: true, event_id: @event.id }
          expect(assigns(:task)).to have_attributes(:done => true)
        end

        it "creates task with valid deadline" do
          expect { 
            post :create, task: { description: "description", name: "Test", deadline: Date.tomorrow, event_id: @event.id} 
          }.to change(Task, :count).by(1)
        end

        describe "with attachments" do 
          it "creates new task" do 
            expect{
             post :create, { task: valid_attributes_with_attachement }
             }.to change(Task, :count).by(1)
          end 

          it "creates new task with attachment" do 
            post :create, { task: valid_attributes_with_attachement }
            expect(assigns(:task).attachments).to_not be_empty()
          end 

          it "creates new attachment" do 
            expect{
             post :create, { task: valid_attributes_with_attachement }
            }.to change(Attachment, :count).by(1) 
          end 

          it "redirects to the newly created @task" do 
            post :create, { task: valid_attributes_with_attachement }
            expect(response).to redirect_to(Task.last.event)
          end
        end

        describe "with user assigned to it" do 
          it "sends an email" do
            params = valid_attributes_with_user
            params[:event_id] = @event.id
            post :create, { :task => params }
            expect(ActionMailer::Base.deliveries.count).to eq(1)
          end
        end 

        describe "without user assigned to it" do 
          it "doesn't send an email " do
            post :create, task: { description: "description", name: "Test", event_id: @event.id }
            expect(ActionMailer::Base.deliveries).to be_empty
          end
        end
      end

      describe "with invalid params" do 
        it "no new Task is saved" do 
          expect{ 
            post :create, { task: invalid_attributes }
          }.to_not change(Task, :count)
        end

        it "does not create new task if deadline is invalid" do
          expect { 
            post :create, task: { description: "description", name: "Test", deadline: Date.today} 
          }.to_not change(Task, :count)
        end

        it "assigns a newly created but unsaved event as @task" do
          post :create, { task: invalid_attributes }
          expect(assigns(:task)).to be_a_new(Task)
        end

        it "re-renders the 'new' template" do
          post :create, { task: invalid_attributes }
          expect(response).to render_template("new")
        end

        it "if for event_template @for_event_template is still true" do
          event_template = FactoryGirl.create :event_template
          get :new, {:event_template_id => event_template.to_param}
          post :create, { task: invalid_attributes }
          expect(assigns(:for_event_template)).to eq(true)
        end

        it "if for event @for_event_template is still false" do
          event = FactoryGirl.create :event
          get :new, {:event_id => event.to_param}
          post :create, { task: invalid_attributes }
          expect(assigns(:for_event_template)).to eq(false)
        end
      end
    end

    describe "GET show" do
      it "successfully shows the task" do 
        get :show, { id: task.to_param } 
        expect(response).to render_template("show")
      end 
      
      it "assigns the requested event as @event" do
        get :show, {:id => task.to_param}
        expect(assigns(:task)).to eq(task)
      end
    end

    describe "GET edit" do 
      it "successfully shows the task" do 
        get :edit, { id: task.to_param } 
        expect(response).to render_template("edit")
      end

      it "assigns the requested event as @event" do
        get :edit, {:id => task.to_param}
        expect(assigns(:task)).to eq(task)
      end
    end

    describe "PATCH update" do
      describe "with valid params" do
        it "updates the task" do 
          expect {
            patch :update, { id: task.to_param, task: valid_attributes_for_task_update}
            task.reload()
          }.to change(task, :updated_at)
        end

        it "redirects to the updated task page" do
          patch :update, { id: task.to_param, task: valid_attributes_for_task_update}
          expect(response).to redirect_to(Task.last)
        end 
        
        it "with done as true marks a task as done" do
          task.done = false
          xhr :put, :update, id: task, task: { done: true }
          expect(assigns(:task)).to have_attributes(:done => true)
        end

        it "with done as false marks a task as undone" do
          task.done = true
          xhr :put, :update, id: task, task: { done: false }
          expect(assigns(:task)).to have_attributes(:done => false)
        end

        it "updates a task with valid deadline" do
          expect { 
            patch :update, { id: task, task: { description: task.description, event_id: task.event_id, name: task.name, deadline: Date.tomorrow }} 
            task.reload()
          }.to change(task, :deadline)
        end
      end 
      
      describe "with invalid params" do 
        it "does not update the task" do 
          expect {
            patch :update, { id: task.to_param, task: invalid_attributes}
          }.not_to change(task, :updated_at)
        end

        it "re-renders the 'edit' template" do
          patch :update, { id: task.to_param, task: invalid_attributes}
          expect(response).to render_template("edit")
        end      
      end

      describe "user is assigned to task" do
        describe "and is removed" do 
          it "sends an email if user was assigned" do
            task = Task.create! valid_attributes_with_user
            patch :update, id: task.to_param, task: { user_id: nil }
            expect(ActionMailer::Base.deliveries.count).to eq(1)
          end 
        end 

        it "sends an email if a user is assigned to an existing task" do
          task = Task.create! valid_attributes
          patch :update, id: task.to_param, task: { user_id: anotherUser.id }
          expect(ActionMailer::Base.deliveries.count).to eq(1)
        end
      end

      describe "another user is assigned to task" do 
        it "sends two emails" do
          task = Task.create! valid_attributes_with_user      
          patch :update, id: task.to_param, task: { user_id: anotherUser.id }
          expect(ActionMailer::Base.deliveries.count).to eq(2)
        end
      end 
    end 
    
    describe "POST update_task_position" do 
      it "sets the task position" do
        secondTask = create(:task)
        xhr :post, :update_task_order, task: { task_id: secondTask.id, task_order_position: 0 }
        expect(Task.rank(:task_order).first).to eq secondTask
      end

      it "is successful" do
        secondTask = create(:task)
        xhr :post, :update_task_order, task: { task_id: secondTask.id, task_order_position: 0 }
        expect(response).to be_success
      end 
    end

    describe "DELETE destroy" do 
      it "destroys a task" do
        taskToDelete = create(:task)
        expect { 
          delete :destroy, id: taskToDelete
        }.to change(Task, :count).by(-1)
      end
      
      it "redirects to the task page" do 
        taskToDelete = create(:task)
        delete :destroy, id: taskToDelete
        expect(response).to redirect_to(Task)
      end
    end

    it "sets the return url when coming from root" do
      request.env["HTTP_REFERER"] = "http://event-und-raumplanung.herokuap.com/"
      get :show, id: task
      expect(assigns(:return_url)).to eq('/')
    end
  end
end
