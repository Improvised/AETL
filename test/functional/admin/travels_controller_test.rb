require 'test_helper'

class Admin::TravelsControllerTest < ActionController::TestCase
  setup do
    @admin_travel = admin_travels(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_travels)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_travel" do
    assert_difference('Admin::Travel.count') do
      post :create, admin_travel: { name: @admin_travel.name }
    end

    assert_redirected_to admin_travel_path(assigns(:admin_travel))
  end

  test "should show admin_travel" do
    get :show, id: @admin_travel
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_travel
    assert_response :success
  end

  test "should update admin_travel" do
    put :update, id: @admin_travel, admin_travel: { name: @admin_travel.name }
    assert_redirected_to admin_travel_path(assigns(:admin_travel))
  end

  test "should destroy admin_travel" do
    assert_difference('Admin::Travel.count', -1) do
      delete :destroy, id: @admin_travel
    end

    assert_redirected_to admin_travels_path
  end
end
