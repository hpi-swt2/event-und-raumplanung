require 'rails_helper'

describe TasksController, type: :controller do
  describe "GET accept" do
    let(:event) { FactoryGirl.create(:event) }
    let(:user) { FactoryGirl.create(:user) }
    let(:assigned_task) { FactoryGirl.create :assigned_task, event_id: event.id, user_id: user.id }
    let(:unassigned_task) { FactoryGirl.create :unassigned_task, event_id: event.id }

    before(:each) { sign_in user }

    it 'should change tasks status of assigned task to accepted' do
      expect{get :accept, id: assigned_task.id}.to change{Task.find(assigned_task.id).status}.from("pending").to("accepted")
    end

    it 'should not change tasks status of unassigned task to accepted' do
      expect{get :accept, id: unassigned_task.id}.to_not change{Task.find(unassigned_task.id).status}
    end
  end

  describe "GET decline" do
    let(:event) { FactoryGirl.create(:event) }
    let(:user) { FactoryGirl.create(:user) }
    let(:assigned_task) { FactoryGirl.create :assigned_task, event_id: event.id, user_id: user.id }
    let(:unassigned_task) { FactoryGirl.create :unassigned_task, event_id: event.id }

    before(:each) { sign_in user }

    it 'should change tasks status of assigned task to declined' do
      expect{get :decline, id: assigned_task.id}.to change{Task.find(assigned_task.id).status}.from("pending").to("declined")
    end

    it 'should not change tasks status of unassigned task to declined' do
      expect{get :decline, id: unassigned_task.id}.to_not change{Task.find(unassigned_task.id).status}
    end
  end

  context "when user is not logged-in" do
    it "redirects unauthenticated calls to login page" do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end
  end
  
  context "when user is logged-in" do
    let(:task) { create :task }
    let(:user) { create :user }
    let(:anotherUser) { create :user }
    let(:valid_attributes) {
      {
        name: "Test",
        done: false,
        description: "description"
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
  
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
      ActionMailer::Base.deliveries.clear
    end
  
    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

    it "loads the events in order to filter tasks" do
      get :index
      expect(assigns(:events)).not_to be_nil
    end
  
    it "gets new" do
      get :new
      expect(response).to be_success
    end
  
    it "creates task" do
      expect { post :create, task: { description: "description", name: "Test" } }.to change { Task.count }.by(1)
      expect(response).to redirect_to task_path(assigns(:task))
    end

    it "creates task that are marked as undone" do
      post :create, task: { description: "description", name: "Test", done: true }
      expect(assigns(:task).done).to be false
    end

    it "creates task with attachments" do
      expect { post :create, task: { description: "description", name: "Test", attachments_attributes: [ { title: "Example", url: "http://example.com"} ]}}.to change { Attachment.count }.by(1)
      expect(response).to redirect_to task_path(assigns(:task))
    end

    it "sets the event for a new task that should belong to the event" do
      get :new, event_id: 1
      expect(assigns(:task).event_id).to eq(1)
      expect(assigns(:event_field_readonly)).to be(:true)
    end
  
    it "shows a task" do
      get :show, id: task
      expect(response).to be_success
    end

    it "sets the return url correctly" do
      get :show, id: task, return_url: '/some/url'
      expect(assigns(:return_url)).to eq('/some/url')
    end
  
    it "edits a task" do
      get :edit, id: task
      expect(response).to be_success
    end
  
    it "updates a task" do
      patch :update, id: task, task: { description: task.description, event_id: task.event_id, name: task.name, user_id: task.user_id, done: task.done }
      expect(response).to redirect_to task_path(assigns(:task))
    end

    it "marks a task as done" do
      task.done = false
      xhr :put, :update, id: task, task: { done: true }
      expect(assigns(:task).done).to be true
    end

    it "marks a task as undone" do
      task.done = true
      xhr :put, :update, id: task, task: { done: false }
      expect(assigns(:task).done).to be false
    end
  
    it "destroys a task" do
      taskToDelete = create(:task)
      expect { delete :destroy, id: taskToDelete }.to change { Task.count }.by(-1)
      expect(response).to redirect_to tasks_path
    end

    it "sends an email if a user is assigned to a new task" do
      post :create, { :task => valid_attributes_with_user }
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

    it "doesn't send an email if no user was assigned to a new task" do
      post :create, task: { description: "description", name: "Test" }
      expect(ActionMailer::Base.deliveries).to be_empty
    end

    it "sends two emails if another user is assigned to task" do
      task = Task.create! valid_attributes_with_user      
      patch :update, id: task.to_param, task: { user_id: anotherUser.id }
      expect(ActionMailer::Base.deliveries.count).to eq(2)
    end

    it "sends an email if a user is assigned to an existing task" do
      task = Task.create! valid_attributes
      patch :update, id: task.to_param, task: { user_id: anotherUser.id }
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

    it "sends an email if the assignment of an existing task is removed" do
      task = Task.create! valid_attributes_with_user
      patch :update, id: task.to_param, task: { user_id: nil }
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
  end
end