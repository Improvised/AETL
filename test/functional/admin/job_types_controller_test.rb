require 'test_helper'

class Admin::JobTypesControllerTest < ActionController::TestCase
  setup do
    @admin_job_type = admin_job_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_job_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_job_type" do
    assert_difference('Admin::JobType.count') do
      post :create, admin_job_type: { name: @admin_job_type.name }
    end

    assert_redirected_to admin_job_type_path(assigns(:admin_job_type))
  end

  test "should show admin_job_type" do
    get :show, id: @admin_job_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_job_type
    assert_response :success
  end

  test "should update admin_job_type" do
    put :update, id: @admin_job_type, admin_job_type: { name: @admin_job_type.name }
    assert_redirected_to admin_job_type_path(assigns(:admin_job_type))
  end

  test "should destroy admin_job_type" do
    assert_difference('Admin::JobType.count', -1) do
      delete :destroy, id: @admin_job_type
    end

    assert_redirected_to admin_job_types_path
  end
end
