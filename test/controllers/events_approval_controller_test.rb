require 'test_helper'

class Events_approvalControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end