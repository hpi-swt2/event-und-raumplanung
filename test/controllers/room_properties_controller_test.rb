require 'test_helper'

class RoomPropertiesControllerTest < ActionController::TestCase
  setup do
    @roomProperty = room_properties(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:roomProperties)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create roomProperty" do
    assert_difference('RoomProperty.count') do
      post :create, room_property: { name: @roomProperty.name }
    end

    assert_redirected_to room_properties_path
  end

  test "should show roomProperty" do
    get :show, id: @roomProperty
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @roomProperty
    assert_response :success
  end

  test "should update roomProperty" do
    patch :update, id: @roomProperty, room_property: { name: @roomProperty.name }
    assert_redirected_to room_properties_path
  end

  test "should destroy roomProperty" do
    assert_difference('RoomProperty.count', -1) do
      delete :destroy, id: @roomProperty
    end

    assert_redirected_to room_properties_path
  end
end
