require 'test_helper'

class Admin::EmployeeProductionsControllerTest < ActionController::TestCase
  setup do
    @admin_employee_production = admin_employee_productions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_employee_productions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_employee_production" do
    assert_difference('Admin::EmployeeProduction.count') do
      post :create, admin_employee_production: { name: @admin_employee_production.name }
    end

    assert_redirected_to admin_employee_production_path(assigns(:admin_employee_production))
  end

  test "should show admin_employee_production" do
    get :show, id: @admin_employee_production
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_employee_production
    assert_response :success
  end

  test "should update admin_employee_production" do
    put :update, id: @admin_employee_production, admin_employee_production: { name: @admin_employee_production.name }
    assert_redirected_to admin_employee_production_path(assigns(:admin_employee_production))
  end

  test "should destroy admin_employee_production" do
    assert_difference('Admin::EmployeeProduction.count', -1) do
      delete :destroy, id: @admin_employee_production
    end

    assert_redirected_to admin_employee_productions_path
  end
end
