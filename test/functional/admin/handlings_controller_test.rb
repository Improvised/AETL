require 'test_helper'

class Admin::HandlingsControllerTest < ActionController::TestCase
  setup do
    @admin_handling = admin_handlings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_handlings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_handling" do
    assert_difference('Admin::Handling.count') do
      post :create, admin_handling: { name: @admin_handling.name }
    end

    assert_redirected_to admin_handling_path(assigns(:admin_handling))
  end

  test "should show admin_handling" do
    get :show, id: @admin_handling
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_handling
    assert_response :success
  end

  test "should update admin_handling" do
    put :update, id: @admin_handling, admin_handling: { name: @admin_handling.name }
    assert_redirected_to admin_handling_path(assigns(:admin_handling))
  end

  test "should destroy admin_handling" do
    assert_difference('Admin::Handling.count', -1) do
      delete :destroy, id: @admin_handling
    end

    assert_redirected_to admin_handlings_path
  end
end
