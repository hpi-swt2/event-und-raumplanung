require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  setup do
    @task = tasks(:one)
    @user = create(:user)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tasks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create task" do
    assert_difference('Task.count') do
      post :create, task: { description: @task.description, event_id: @task.event_id, name: @task.name, done: @task.done }
    end

    assert_redirected_to task_path(assigns(:task))
  end

  test "should create attachments for new task" do
    assert_difference('Attachment.count') do
      post :create, task: { description: @task.description, event_id: @task.event_id, name: @task.name,
                            attachments_attributes: [ { title: "Example", url: "http://example.com" } ] }
    end

    assert_redirected_to task_path(assigns(:task))
  end

  test "should show task" do
    get :show, id: @task
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @task
    assert_response :success
  end

  test "should update task" do
    patch :update, id: @task, task: { description: @task.description, event_id: @task.event_id, name: @task.name, done: @task.done }
    assert_redirected_to task_path(assigns(:task))
  end

  test "should destroy task" do
    assert_difference('Task.count', -1) do
      delete :destroy, id: @task
    end

    assert_redirected_to tasks_path
  end

  test "should send email if user was assigned to task" do
    create_task
    assert_not ActionMailer::Base.deliveries.empty?, "no email notification sent"
    empty_mailer_list
  end

  test "should not send email if no user was assigned to task" do
    empty_mailer_list
    post :create, task: { description: @task.description, event_id: @task.event_id, name: @task.name }
    assert ActionMailer::Base.deliveries.empty?, "email notification sent"
    empty_mailer_list
  end

  test "should send email if user of task is changed" do
    newUser = users(:two)
    create_task
    empty_mailer_list
    
    patch :update, id: @task.id, task: { user_id: newUser.id }
    assert_not ActionMailer::Base.deliveries.empty?, "no email notification to newly assigned user sent"
    empty_mailer_list
  end

  def create_task
    post :create, task: { description: @task.description, event_id: @task.event_id, name: @task.name, user_id: @user.id }
  end

  def empty_mailer_list
    ActionMailer::Base.deliveries.clear
  end
end
