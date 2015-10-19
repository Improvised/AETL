require 'test_helper'

class Admin::EmployeeProjectManagersControllerTest < ActionController::TestCase
  setup do
    @admin_employee_project_manager = admin_employee_project_managers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_employee_project_managers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_employee_project_manager" do
    assert_difference('Admin::EmployeeProjectManager.count') do
      post :create, admin_employee_project_manager: { name: @admin_employee_project_manager.name }
    end

    assert_redirected_to admin_employee_project_manager_path(assigns(:admin_employee_project_manager))
  end

  test "should show admin_employee_project_manager" do
    get :show, id: @admin_employee_project_manager
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_employee_project_manager
    assert_response :success
  end

  test "should update admin_employee_project_manager" do
    put :update, id: @admin_employee_project_manager, admin_employee_project_manager: { name: @admin_employee_project_manager.name }
    assert_redirected_to admin_employee_project_manager_path(assigns(:admin_employee_project_manager))
  end

  test "should destroy admin_employee_project_manager" do
    assert_difference('Admin::EmployeeProjectManager.count', -1) do
      delete :destroy, id: @admin_employee_project_manager
    end

    assert_redirected_to admin_employee_project_managers_path
  end
end
