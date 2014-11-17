require 'test_helper'

class AttachmentsControllerTest < ActionController::TestCase
  setup do
    @attachment = attachments(:one)
  end

  test "should get index" do
    xhr :get, :index
    assert_response :success
    assert_not_nil assigns(:attachments)
  end

  test "should create attachment" do
    assert_difference('Attachment.count') do
      xhr :post, :create, attachment: { task_id: @attachment.task_id, title: @attachment.title, url: @attachment.url }
    end

    assert_response :success
  end

  test "should destroy attachment" do
    assert_difference('Attachment.count', -1) do
      xhr :delete, :destroy, id: @attachment
    end

    assert_response :success
  end
end
