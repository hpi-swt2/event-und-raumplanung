require 'rails_helper'

RSpec.describe TasksController, type: :controller do
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
    let(:invalid_attributes) {
      {
        name: '',
      }
    }

    let(:valid_session) { {} }
  
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

    it "creates task with uploads" do
      expect { post :create, task: {description: "description", name: "Test"}, uploads: [fixture_file_upload('files/test_pdf.pdf', 'application/pdf')] }.to change { Upload.count }.by(1)
      expect(response).to redirect_to task_path(assigns(:task))
    end

    context 'invalid upload' do
      it "does not create task with upload in wrong format" do
        expect { post :create, task: {description: "description", name: "Test"}, uploads: [fixture_file_upload('files/test_forbidden_format_goto.exe', 'application/x-dosexec')] }.to_not change { Upload.count }
        expect { post :create, task: {description: "description", name: "Test"}, uploads: [fixture_file_upload('files/test_forbidden_format_goto.exe', 'application/x-dosexec')] }.to_not change { Task.count }
        expect(response).to be_success  # redicrects to 'new' page with filled-in values
      end

      it "does not create task with too big upload" do
        expect { post :create, task: {description: "description", name: "Test"}, uploads: [fixture_file_upload('files/too_big_file.png', 'image/png')] }.to_not change { Upload.count }
        expect { post :create, task: {description: "description", name: "Test"}, uploads: [fixture_file_upload('files/too_big_file.png', 'image/png')] }.to_not change { Task.count }
        expect(response).to be_success  # redicrects to 'new' page with filled-in values
      end
    end

    it "sets the event for a new task that should belong to the event" do
      get :new, event_id: 1
      expect(assigns(:task).event_id).to eq(1)
      expect(assigns(:event_field_readonly)).to be(:true)
    end
    
    it "creates task with valid deadline" do
      expect { post :create, task: { description: "description", name: "Test", deadline: Date.tomorrow} }.to change { Task.count }.by(1)
      expect(response).to redirect_to task_path(assigns(:task))
    end

    it "creates task with invalid deadline" do
      expect { post :create, task: { description: "description", name: "Test", deadline: Date.today} }.to change { Task.count }.by(0)
      expect(response).to render_template("new")
    end

    it "creates task with invalid deadline" do
      expect { post :create, task: { description: "description", name: "Test", deadline: Date.yesterday} }.to change { Task.count }.by(0)
      expect(response).to render_template("new")
    end

    it "shows a task" do
      get :show, id: task
      expect(response).to be_success
    end

    it "sets the return url when coming from root" do
      request.env["HTTP_REFERER"] = "http://event-und-raumplanung.herokuap.com/"
      get :show, id: task
      expect(assigns(:return_url)).to eq('/')
    end
  
    it "edits a task" do
      get :edit, id: task
      expect(response).to be_success
    end   
  
    it "updates a task" do
      patch :update, id: task, task: { description: task.description, event_id: task.event_id, name: task.name, user_id: task.user_id, done: task.done }
      expect(response).to redirect_to task_path(assigns(:task))
    end

    it "updates a task with uploads" do
      expect { patch :update, id: task, task: {description: "description", name: "Test"}, uploads: [fixture_file_upload('files/test_pdf.pdf', 'application/pdf')] }.to change { Upload.count }.by(1)
      upload_id = Upload.find_by(file_file_name: 'test_pdf.pdf').id      
      expect { patch :update, id: task,  task: {description: "description", name: "Test"}, delete_uploads: Hash[upload_id, 'true'] }.to change { Upload.count }.from(1).to(0)
      expect(response).to redirect_to task_path(assigns(:task))
    end

    context 'invalid upload' do
      it "updates a task with upload in wrong format" do
        expect { patch :update, id: task, task: {description: "description", name: "Test"}, uploads: [fixture_file_upload('files/test_forbidden_format_goto.exe', 'application/x-dosexec')] }.to_not change { Upload.count }
        expect(response).to be_success  # redirect back to 'edit' page
      end

      it "updates a task with too big upload" do
        expect { patch :update, id: task, task: {description: "description", name: "Test"}, uploads: [fixture_file_upload('files/too_big_file.png', 'image/png')] }.to_not change { Upload.count }
        expect(response).to be_success  # redirect back to 'edit' page
      end
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

    it "sets the task position" do
      firstTask = create(:task)
      secondTask = create(:task)
      xhr :post, :update_task_order, task: { task_id: secondTask.id, task_order_position: 0 }
      expect(Task.rank(:task_order).first).to eq secondTask
    end

    it "updates a task with valid deadline" do
      patch :update, id: task, task: { description: task.description, event_id: task.event_id, name: task.name, deadline: Date.tomorrow }
      expect(response).to redirect_to task_path(assigns(:task))
    end

    it "updates a task" do
      patch :update, id: task, task: { description: task.description, event_id: task.event_id, name: task.name, deadline: Date.today }
      expect(response).to render_template("edit")
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

    it "renders the 'new' template" do
      post :create, {:task => invalid_attributes}, valid_session
      expect(response).to render_template("new")
    end

    it "should render the edit page when wrong parameters are passed to update" do
      put :update, {:id => task.to_param, :task => invalid_attributes}, valid_session
      expect(response).to render_template("edit")
    end
  end
end