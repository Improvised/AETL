require 'test_helper'

class Admin::JobStatusesControllerTest < ActionController::TestCase
  setup do
    @admin_job_status = admin_job_statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_job_statuses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_job_status" do
    assert_difference('Admin::JobStatus.count') do
      post :create, admin_job_status: { name: @admin_job_status.name }
    end

    assert_redirected_to admin_job_status_path(assigns(:admin_job_status))
  end

  test "should show admin_job_status" do
    get :show, id: @admin_job_status
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_job_status
    assert_response :success
  end

  test "should update admin_job_status" do
    put :update, id: @admin_job_status, admin_job_status: { name: @admin_job_status.name }
    assert_redirected_to admin_job_status_path(assigns(:admin_job_status))
  end

  test "should destroy admin_job_status" do
    assert_difference('Admin::JobStatus.count', -1) do
      delete :destroy, id: @admin_job_status
    end

    assert_redirected_to admin_job_statuses_path
  end
end
