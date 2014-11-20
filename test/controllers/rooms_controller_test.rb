require 'test_helper'

class RoomsControllerTest < ActionController::TestCase
  setup do
    @room = rooms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rooms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create room" do
    assert_difference('Room.count') do
      post :create, room: { name: @room.name, size: @room.size }
    end

    assert_redirected_to room_path(assigns(:room))
  end

  test "should show room" do
    get :show, id: @room
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @room
    assert_response :success
  end

  test "should update room" do
    patch :update, id: @room, room: { name: @room.name, size: @room.size }
    assert_redirected_to room_path(assigns(:room))
  end

  test "should destroy room" do
    assert_difference('Room.count', -1) do
      delete :destroy, id: @room
    end

    assert_redirected_to rooms_path
  end

  test "should get no Selection" do
    get :list
    assert_response :success
    assert_not_nil assigns(:empty)
    assert_not_nil assigns(:noSelection)
    assert_equal(true, assigns(:noSelection))
    assert_equal(false, assigns(:empty))
  end
  
  test "should room filter list" do
    get :list, utf8: "✓", room:{"size" => 5}, commit:"Suche"
    assert_response :success
    assert_not_nil assigns(:empty)
    assert_not_nil assigns(:noSelection)
    assert_equal(false, assigns(:noSelection))
    assert_equal(false, assigns(:empty))
    assert_equal(1, assigns(:rooms).size)
    assert_equal(rooms(:three).id, assigns(:rooms).first.id)
  end

  test "should get empty list" do
    get :list, utf8: "✓", room:{"size" =>37458375}, commit:"Suche"
    assert_response :success
    assert_not_nil assigns(:empty)
    assert_not_nil assigns(:noSelection)
    assert_equal(false, assigns(:noSelection))
    assert_equal(true, assigns(:empty))
    assert_equal(0, assigns(:rooms).size)
  end


  test "should room filter list for Beamer and size = 5" do
    get :list, utf8: "✓", room:{"size" => 5}, Beamer: 1, commit:"Suche"
    assert_response :success
    assert_not_nil assigns(:empty)
    assert_not_nil assigns(:noSelection)
    assert_equal(false, assigns(:noSelection))
    assert_equal(false, assigns(:empty))
    assert_equal(1, assigns(:rooms).size)
    assert_equal(rooms(:three).id, assigns(:rooms).first.id)
  end

  test "should room filter list for WLAN and size = 0" do
    get :list, utf8: "✓", room:{"size" => 0}, WLAN: 1, commit:"Suche"
    assert_response :success
    assert_not_nil assigns(:empty)
    assert_not_nil assigns(:noSelection)
    assert_equal(false, assigns(:noSelection))
    assert_equal(false, assigns(:empty))
    assert_equal(1, assigns(:rooms).size)
    assert_equal(rooms(:one).id, assigns(:rooms).first.id)
  end
  test "should get empty list for WLAN and Beamer" do
    get :list, utf8: "✓", room:{"size" => 1}, WLAN: 1, Beamer: 1, commit:"Suche"
    assert_response :success
    assert_not_nil assigns(:empty)
    assert_not_nil assigns(:noSelection)
    assert_equal(false, assigns(:noSelection))
    assert_equal(true, assigns(:empty))
    assert_equal(0, assigns(:rooms).size)
  end
end
