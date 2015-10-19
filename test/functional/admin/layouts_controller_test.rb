require 'test_helper'

class Admin::LayoutsControllerTest < ActionController::TestCase
  setup do
    @admin_layout = admin_layouts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_layouts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_layout" do
    assert_difference('Admin::Layout.count') do
      post :create, admin_layout: { landscape: @admin_layout.landscape, name: @admin_layout.name, tabloid: @admin_layout.tabloid }
    end

    assert_redirected_to admin_layout_path(assigns(:admin_layout))
  end

  test "should show admin_layout" do
    get :show, id: @admin_layout
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_layout
    assert_response :success
  end

  test "should update admin_layout" do
    put :update, id: @admin_layout, admin_layout: { landscape: @admin_layout.landscape, name: @admin_layout.name, tabloid: @admin_layout.tabloid }
    assert_redirected_to admin_layout_path(assigns(:admin_layout))
  end

  test "should destroy admin_layout" do
    assert_difference('Admin::Layout.count', -1) do
      delete :destroy, id: @admin_layout
    end

    assert_redirected_to admin_layouts_path
  end
end
