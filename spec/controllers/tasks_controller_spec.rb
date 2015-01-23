require 'rails_helper'
require 'pry'

RSpec.describe TasksController, type: :controller do
    let(:event) { create :event }
    let(:user) { create :user }
    let(:another_user) { create :user }
    let(:task) { FactoryGirl.create :task }
    let(:group) { create :group, users: [user, another_user]}
    let(:assigned_task) { create :assigned_task, event_id: event.id, identity: user }
    let(:unassigned_task) { create :unassigned_task, event_id: event.id }
    let(:assigned_task_group) { create :assigned_task, event_id: event.id, identity: group}
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

    it 'should change assigned person from group to accepting user' do 
      get :accept, id: assigned_task_group.id
      expect(Task.find(assigned_task_group.id).status).to eq 'accepted'
      expect(Task.find(assigned_task_group.id).identity_id).to eq user.id
      expect(Task.find(assigned_task_group.id).identity_type).to eq 'User'
    end

    it 'should promt an error message to another User from the assigned group who wants to accept an already accepted task' do 
      pending("redirects to tasks/task.id and not to root_path & flash warning is nil")
      get :accept, id: assigned_task_group.id
      sign_in another_user
      get :accept, id: assigned_task_group.id
      expect(Task.find(assigned_task_group.id).identity_id).to_not eq another_user.id
      expect(flash[:warning]).should_not be_nil
      expect(response).to redirect_to root_path
    end

    it 'should not change declined task to accepted' do 
      get :decline, id: assigned_task_group.id
      get :accept, id: assigned_task_group.id
      expect(Task.find(assigned_task_group.id).status).to eq 'declined'
    end
  end

  describe "GET decline" do
    let(:event) { FactoryGirl.create(:event) }
    let(:user) { FactoryGirl.create(:user) }
    let(:another_user) { create :user }
    let(:group) { create :group, users: [user, another_user]}
    let(:assigned_task) { FactoryGirl.create :assigned_task, event_id: event.id, identity: user }
    let(:unassigned_task) { FactoryGirl.create :unassigned_task, event_id: event.id }
    let(:assigned_task_group) { create :assigned_task, event_id: event.id, identity: group}
    
    before(:each) { sign_in user }

    it 'should change tasks status of assigned task to declined' do
      expect{get :decline, id: assigned_task.id}.to change{Task.find(assigned_task.id).status}.from("pending").to("declined")
    end

    it 'should not change tasks status of unassigned task to declined' do
      expect{get :decline, id: unassigned_task.id}.to_not change{Task.find(unassigned_task.id).status}
    end

    it 'should change task assigned to group from pending to declined' do 
      get :decline, id: assigned_task_group.id
      expect(Task.find(assigned_task_group.id).status).to eq 'declined'
    end

    it 'should not change accepted task to declined' do 
      get :accept, id: assigned_task_group.id
      get :decline, id: assigned_task_group.id
      expect(Task.find(assigned_task_group.id).status).to eq 'accepted'
    end
  end

  context "when user is not logged-in" do
    it "redirects unauthenticated calls to login page" do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end
  end
  
  context "when user is logged-in" do
    let(:user) { create :user }
    let(:anotherUser) { create :user }
    let(:group) { create :group, users: [user, anotherUser]}
    let(:event) { create :event, user_id: user.id }
    let(:task) { create :task, event_id: event.id, identity: user }
    let(:task_with_group) { create :task, event_id: event.id, identity: group }  
    let(:unassigned_task) { create :unassigned_task, event_id: event.id }
    let(:valid_attributes) {
      {
        name: "Test",
        done: false,
        description: "description",
        event_id: event.id
      }
    }
    let(:valid_attributes_with_user) {
      {
        name: "Test",
        done: false,
        description: "description",
        identity: user,
        event_id: event.id
      }
    }
    let(:valid_parameters_with_user) {
      {
        name: "Test",
        done: false,
        description: "description",
        identity: "User:" + user.id.to_s,
        event_id: event.id
      }
    }
    let(:valid_attributes_with_group) {
      {
        name: "Test",
        done: false,
        description: "description",
        identity: group,
        event_id: event.id
      }
    }
    let(:valid_parameters_with_group) {
      {
        name: "Test",
        done: false,
        description: "description",
        identity: "Group:" + group.id.to_s,
        event_id: event.id
      }
    }
    let(:invalid_attributes) {
      {
        name: '',
        event_id: event.id 
      }
    }

    let(:valid_session) { {} }

    def identity_dummy(task)
      return task.identity_type.to_s + ':' + task.identity_id.to_s
    end

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


    describe "GET new" do
      before(:all) do
        DatabaseCleaner.clean
        DatabaseCleaner.start
      end

      it "gets new" do
        get :new
        expect(response).to be_success
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
  
    it "creates task" do
      expect { post :create, task: { description: "description", name: "Test", event_id: event.id } }
        .to change { Task.count }.by(1)
      expect(response).to redirect_to task_path(assigns(:task))
    end

    it "creates an activity when a task is created with an event id" do
      post :create, task: { description: "description", name: "Test", event_id: event.id } 
      
      activity = event.activities.last

      expect(activity.action).to eq("create")
      expect(activity.controller).to eq("tasks")
    end

    it "creates task that are marked as undone" do
      post :create, task: { description: "description", name: "Test" }
      expect(assigns(:task).done).to be false
    end

    it "creates task with status 'not assigned' if no one is assigned" do
      post :create, task: valid_attributes
      expect(assigns(:task).status).to eq 'not_assigned'
    end

    it "creates task with status 'pending' if a user is assigned" do
      post :create, task: valid_parameters_with_user
      expect(assigns(:task).status).to eq 'pending'
    end

    it "creates task with attachments" do
      expect { post :create, task: { description: "description", name: "Test", event_id: event.id, 
        attachments_attributes: [ { title: "Example", url: "http://example.com"} ]}}
        .to change { Attachment.count }.by(1)
      expect(response).to redirect_to task_path(assigns(:task))
    end

    it "creates task with uploads" do
      expect { post :create, task: {description: "description", name: "Test", event_id: event.id}, uploads: [fixture_file_upload('files/test_pdf.pdf', 'application/pdf')] }.to change { Upload.count }.by(1)
      expect(response).to redirect_to task_path(assigns(:task))
    end

    context 'invalid upload' do
      it "does not create task with upload in wrong format" do
        expect { post :create, task: {description: "description", name: "Test", event_id: event.id}, uploads: [fixture_file_upload('files/test_forbidden_format_goto.exe', 'application/x-dosexec')] }.to_not change { Upload.count }
        expect { post :create, task: {description: "description", name: "Test", event_id: event.id}, uploads: [fixture_file_upload('files/test_forbidden_format_goto.exe', 'application/x-dosexec')] }.to_not change { Task.count }
        expect(response).to be_success  # redirects to 'new' page with filled-in values
      end

      it "does not create task with too big upload" do
        expect { post :create, task: {description: "description", name: "Test", event_id: event.id}, uploads: [fixture_file_upload('files/too_big_file.png', 'image/png')] }.to_not change { Upload.count }
        expect { post :create, task: {description: "description", name: "Test", event_id: event.id}, uploads: [fixture_file_upload('files/too_big_file.png', 'image/png')] }.to_not change { Task.count }
        expect(response).to be_success  # redirects to 'new' page with filled-in values
      end
    end

    it "sets the event for a new task that should belong to the event" do
      get :new, event_id: 1
      expect(assigns(:task).event_id).to eq(1)
      get :new
      expect(assigns(:task).event_id).to eq(nil)
      expect(assigns(:event_field_readonly)).to be(:true)
    end
    
    it "creates task with valid deadline" do
      expect { post :create, task: { description: "description", name: "Test", deadline: Date.tomorrow , event_id: event.id} }.to change { Task.count }.by(1)
      expect(response).to redirect_to task_path(assigns(:task))
    end

    it "creates task with invalid deadline" do
      expect { post :create, task: { description: "description", name: "Test", deadline: Date.today, event_id: event.id} }.to change { Task.count }.by(0)
      expect(response).to render_template("new")
    end

    it "creates task with invalid deadline" do
      expect { post :create, task: { description: "description", name: "Test", deadline: Date.yesterday, event_id: event.id} }.to change { Task.count }.by(0)
      expect(response).to render_template("new")
    end

    it "shows a task and assigns belonging event to @event" do
      get :show, id: task
      expect(assigns(:event)).to eq(event)
      expect(response).to be_success
    end

    it "sets the return url when coming from root" do
      request.env["HTTP_REFERER"] = "http://event-und-raumplanung.herokuap.com/"
      get :show, id: task
      expect(assigns(:return_url)).to eq('/')
    end
  
    it "edits a task without assigned identity" do
      get :edit, id: unassigned_task
      expect(assigns(:identity_name)).to eq ""
      expect(response).to be_success
    end

    it "edits a task with assigned user" do
      get :edit, id: task
      expect(assigns(:identity_name)).to eq "#{user.username}"
      expect(response).to be_success
    end   

    it "edits a task with assigned group" do
      get :edit, id: task_with_group
      expect(assigns(:identity_name)).to eq "#{group.name} (#{I18n.t('groups.group')})"
      expect(response).to be_success
    end

    it "updates a task" do
      patch :update, id: task, task: { description: task.description, event_id: task.event_id, name: task.name, done: task.done, identity: identity_dummy(task)}
      expect(response).to redirect_to task_path(assigns(:task))
    end

    it "updates the task status to 'not assigned' if no one is assigned" do
      task.status = 'pending'
      patch :update, id: task, task: { identity: nil }
      expect(assigns(:task).status).to eq 'not_assigned'
    end

    it "updates the task status to 'pending' if a user is assigned" do
      patch :update, id: unassigned_task, task: { identity: 'User:' + user.id.to_s }
      expect(assigns(:task).status).to eq 'pending'
    end

    it "updates a task with uploads" do
      expect { patch :update, id: task, task: { description: "description", name: "Test", identity: identity_dummy(task) }, uploads: [fixture_file_upload('files/test_pdf.pdf', 'application/pdf')] }.to change { Upload.count }.by(1)
      upload_id = Upload.find_by(file_file_name: 'test_pdf.pdf').id      
      expect { patch :update, id: task,  task: {description: "description", name: "Test" , identity: identity_dummy(task) }, delete_uploads: Hash[upload_id, 'true'] }.to change { Upload.count }.from(1).to(0)
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
      xhr :put, :set_done, id: task, task: { done: true }
      expect(assigns(:task).done).to be true
    end

    it "creates an activity when a task is marked as done" do
      task.done = false
      patch :update, id: task, task: { event_id: event.id, done: true }
      activity = event.activities.last

      expect(activity.action).to eq("update")
      expect(activity.controller).to eq("tasks")
      expect(activity.task_info[0]).to eq(task.name)
      expect(activity.task_info[1]).to eq(true)
    end

    it "marks a task as undone" do
      task.done = true
      xhr :put, :set_done, id: task, task: { done: false }
      expect(assigns(:task).done).to be false
    end

    it "creates an activity when a task is marked as undone" do
      task.done = false
      patch :update, id: task, task: { event_id: event.id, done: false }
      activity = event.activities.last

      expect(activity.action).to eq("update")
      expect(activity.controller).to eq("tasks")
      expect(activity.task_info[0]).to eq(task.name)
      expect(activity.task_info[1]).to eq(false)
    end

    it "sets the task position" do
      firstTask = create(:task, event_id: event.id)
      secondTask = create(:task, event_id: event.id)
      xhr :post, :update_task_order, task: { task_id: secondTask.id, task_order_position: 0 }
      expect(Task.rank(:task_order).first).to eq secondTask
    end

    it "updates a task with valid deadline" do
      patch :update, id: task, task: { description: task.description, event_id: task.event_id, name: task.name, deadline: Date.tomorrow, identity: identity_dummy(task) }
      expect(response).to redirect_to task_path(assigns(:task))
    end

    it "updates a task" do
      patch :update, id: task, task: { description: task.description, event_id: task.event_id, name: task.name, deadline: Date.today, identity: identity_dummy(task) }
      expect(response).to render_template("edit")
    end
  
    it "destroys a task" do
      taskToDelete = create(:task, event_id: event.id)
      expect { delete :destroy, id: taskToDelete }.to change { Task.count }.by(-1)
      expect(response).to redirect_to event_path(taskToDelete.event_id)
    end

    it "sends an email if a user is assigned to a new task" do
      post :create, { :task => valid_parameters_with_user }
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

    it "doesn't send an email if no user was assigned to a new task" do
      post :create, task: { description: "description", name: "Test", event_id: event.id }
      expect(ActionMailer::Base.deliveries).to be_empty
    end

    it "sends two emails if another user is assigned to task" do
      task = Task.create! valid_attributes_with_user
      patch :update, id: task.to_param, task: { identity: "User:" + anotherUser.id.to_s }
      expect(ActionMailer::Base.deliveries.count).to eq(2)
    end

    it "sends an email if a user is assigned to an existing task" do
      task = Task.create! valid_attributes
      patch :update, id: task.to_param, task: { identity: 'User:' + user.id.to_s }
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

    it "sends an email if the user assignment of an existing task is removed" do
      task = Task.create! valid_attributes_with_user
      patch :update, id: task.to_param, task: { identity: nil }
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

    it "sends an email to all group members if a group is assigned to a new task" do
      post :create, { :task => valid_parameters_with_group }
      expect(ActionMailer::Base.deliveries.count).to eq(2)
    end

    it "sends emails to user and group if assignment was changed from user to group" do
      task = Task.create! valid_attributes_with_user
      patch :update, id: task.to_param, task: { identity: 'Group:' + group.id.to_s }
      expect(ActionMailer::Base.deliveries.count).to eq(3)
    end

    it "sends an email to all group members if a group is assigned to an existing task" do
      task = Task.create! valid_attributes
      patch :update, id: task.to_param, task: { identity: 'Group:' + group.id.to_s }
      expect(ActionMailer::Base.deliveries.count).to eq(2)
    end

    it "sends an email if the group assignment of an existing task is removed" do
      task = Task.create! valid_attributes_with_group
      patch :update, id: task.to_param, task: { identity: nil }
      expect(ActionMailer::Base.deliveries.count).to eq(2)
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

  describe "user authorization" do
    let(:unprivileged_user) { create :user }
    let(:event_owner) { create :user }
    let(:assigned_user) { create :user }
    let(:event) { create :event, user_id: event_owner.id }
    let(:assigned_task) { create :assigned_task, event_id: event.id, identity: assigned_user }
    let!(:task) { create :task, event_id: event.id }

    def log_in(user)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    end

    it "should not show the task details to the unprivileged user" do
      log_in unprivileged_user
      get :show, { :id => task.to_param }
      expect(response).to redirect_to root_path
    end

    it "should not show the foreign task details to the assigned user" do
      log_in assigned_user
      get :show, { :id => task.to_param }
      expect(response).to redirect_to root_path
    end

    it "should not show the task edit page to the assigned user" do
      log_in assigned_user
      get :edit, { :id => task.to_param }
      expect(response).to redirect_to root_path
    end

    it "should not show the task edit page to the unprivileged user" do
      log_in unprivileged_user
      get :edit, { :id => task.to_param }
      expect(response).to redirect_to root_path
    end

    it "should not update the task with the assigned user's changes" do
      log_in assigned_user
      expect { patch :update, id: task, task: { name: 'Another name' } }
        .to_not change{task.name}
      expect(response).to redirect_to root_path
    end

    it "should not allow the assigned user to change the task order" do
      log_in assigned_user
      expect { patch :update_task_order, task: { task_id: assigned_task.id, task_order_position: 999 } }
        .to_not change{task.task_order_position}
      expect(response).to redirect_to root_path
    end

    it "should not allow the unprivileged user to mark the task as done" do
      log_in unprivileged_user
      expect { xhr :patch, :set_done, id: task, task: { done: !task.done } }
        .to_not change{task.done}
      expect(response).to redirect_to root_path
    end

    it "should allow the event owner to mark the task as done" do
      log_in event_owner
      
      task.done = false
      xhr :put, :set_done, id: task, task: { done: true }
      expect(assigns(:task).done).to be true
    end

    it "should allow the assigned user to mark the task as done" do
      log_in assigned_user
      
      assigned_task.done = false
      xhr :put, :set_done, id: assigned_task, task: { done: true }
      expect(assigns(:task).done).to be true
    end

    it "should not allow the unprivileged user to accept or decline the task" do
      log_in unprivileged_user
      expect { get :accept, id: assigned_task.id }.to_not change{assigned_task.status}
      expect { get :decline, id: assigned_task.id }.to_not change{assigned_task.status}
    end

    it "should not allow the event owner to accept or decline the task" do
      log_in event_owner
      expect { get :accept, id: assigned_task.id }.to_not change{assigned_task.status}
      expect { get :decline, id: assigned_task.id }.to_not change{assigned_task.status}
    end

    it "should not allow the unprivileged user to delete the task" do
      log_in unprivileged_user
      expect { delete :destroy, id: task.id }.to_not change { Task.count }
      expect(response).to redirect_to root_path
    end

    it "should not allow the unprivileged user to create a task" do
      log_in unprivileged_user
      expect { post :create, task: { description: "description", name: "Test", event_id: event.id } }
        .to_not change { Task.count }
      expect(response).to redirect_to root_path
    end

    it "should not allow the assigned user to create a task" do
      log_in assigned_user
      expect { post :create, task: { description: "description", name: "Test", event_id: event.id } }
        .to_not change { Task.count }
      expect(response).to redirect_to root_path
    end

    it "should not allow the assigned user to decline the task after he accepted" do
      log_in assigned_user
      assigned_task.status = 'accepted'
      expect { get :decline, id: assigned_task.id }.to_not change{assigned_task.status}
      expect(response).to redirect_to task_path(assigned_task)
    end
  end
end