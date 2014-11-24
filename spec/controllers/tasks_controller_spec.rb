require 'rails_helper'

RSpec.describe TasksController, :type => :controller do
  context "when user is not logged-in" do
    it "redirects unauthenticated calls to login page" do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context "when user is logged-in" do
    let(:task) { create :task }
    let(:user) { create :user }

    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

    it "gets new" do
      get :new
      expect(response).to be_success
    end

    it "creates task" do
      expect { post :create, task: { description: "description", name: "Test" } }.to change { Task.count }.by(1)
      expect(response).to redirect_to task_path(assigns(:task))
    end

    it "shows a task" do
      get :show, id: task
      expect(response).to be_success
    end

    it "edits a task" do
      get :edit, id: task
      expect(response).to be_success
    end

    it "updates a task" do
      patch :update, id: task, task: { description: task.description, event_id: task.event_id, name: task.name }
      expect(response).to redirect_to task_path(assigns(:task))
    end

    it "destroys a task" do
      taskToDelete = create(:task)
      expect { delete :destroy, id: taskToDelete }.to change { Task.count }.by(-1)
      expect(response).to redirect_to tasks_path
    end
  end
end
