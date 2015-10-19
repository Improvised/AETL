require 'test_helper'

class Admin::CompaniesControllerTest < ActionController::TestCase
  setup do
    @admin_company = admin_companies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_companies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_company" do
    assert_difference('Admin::Company.count') do
      post :create, admin_company: { address_line_1: @admin_company.address_line_1, address_line_2: @admin_company.address_line_2, ar_notes: @admin_company.ar_notes, billing_to_company_id: @admin_company.billing_to_company_id, city: @admin_company.city, email: @admin_company.email, fax: @admin_company.fax, name: @admin_company.name, phone: @admin_company.phone, sale_id: @admin_company.sale_id, state: @admin_company.state, website: @admin_company.website, zip_code: @admin_company.zip_code }
    end

    assert_redirected_to admin_company_path(assigns(:admin_company))
  end

  test "should show admin_company" do
    get :show, id: @admin_company
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_company
    assert_response :success
  end

  test "should update admin_company" do
    put :update, id: @admin_company, admin_company: { address_line_1: @admin_company.address_line_1, address_line_2: @admin_company.address_line_2, ar_notes: @admin_company.ar_notes, billing_to_company_id: @admin_company.billing_to_company_id, city: @admin_company.city, email: @admin_company.email, fax: @admin_company.fax, name: @admin_company.name, phone: @admin_company.phone, sale_id: @admin_company.sale_id, state: @admin_company.state, website: @admin_company.website, zip_code: @admin_company.zip_code }
    assert_redirected_to admin_company_path(assigns(:admin_company))
  end

  test "should destroy admin_company" do
    assert_difference('Admin::Company.count', -1) do
      delete :destroy, id: @admin_company
    end

    assert_redirected_to admin_companies_path
  end
end
