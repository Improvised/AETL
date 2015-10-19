require 'test_helper'

class Admin::SalesControllerTest < ActionController::TestCase
  setup do
    @admin_sale = admin_sales(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_sales)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_sale" do
    assert_difference('Admin::Sale.count') do
      post :create, admin_sale: { name: @admin_sale.name }
    end

    assert_redirected_to admin_sale_path(assigns(:admin_sale))
  end

  test "should show admin_sale" do
    get :show, id: @admin_sale
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_sale
    assert_response :success
  end

  test "should update admin_sale" do
    put :update, id: @admin_sale, admin_sale: { name: @admin_sale.name }
    assert_redirected_to admin_sale_path(assigns(:admin_sale))
  end

  test "should destroy admin_sale" do
    assert_difference('Admin::Sale.count', -1) do
      delete :destroy, id: @admin_sale
    end

    assert_redirected_to admin_sales_path
  end
end
