require 'test_helper'

class EquipmentControllerTest < ActionController::TestCase
  setup do
    @equipment = equipment(:one)
    @user = create(:user)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:equipment)
  end

  test "should get new" do
    get :new
    assert_response :redirect
  end

  test "should create equipment" do
    post :create, equipment: { description: @equipment.description, name: @equipment.name, room_id: @equipment.room_id, category: @equipment.category }
    assert_response :redirect
  end

  test "should show equipment" do
    get :show, id: @equipment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @equipment
    assert_response :redirect
  end

  test "should update equipment" do
    patch :update, id: @equipment, equipment: { description: @equipment.description, name: @equipment.name, room_id: @equipment.room_id, category: @equipment.category }
    assert_response :redirect
  end

  test "should destroy equipment" do
    delete :destroy, id: @equipment
    assert_response :redirect  
  end
end
