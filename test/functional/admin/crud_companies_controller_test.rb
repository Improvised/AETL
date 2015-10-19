require 'test_helper'

class Admin::CrudCompaniesControllerTest < ActionController::TestCase
  setup do
    @admin_crud_company = admin_crud_companies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_crud_companies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_crud_company" do
    assert_difference('Admin::CrudCompany.count') do
      post :create, admin_crud_company: { address_line_1: @admin_crud_company.address_line_1, address_line_2: @admin_crud_company.address_line_2, ar_notes: @admin_crud_company.ar_notes, billing_to_company_id: @admin_crud_company.billing_to_company_id, city: @admin_crud_company.city, email: @admin_crud_company.email, fax: @admin_crud_company.fax, name: @admin_crud_company.name, phone: @admin_crud_company.phone, sale_id: @admin_crud_company.sale_id, state: @admin_crud_company.state, website: @admin_crud_company.website, zip_code: @admin_crud_company.zip_code }
    end

    assert_redirected_to admin_crud_company_path(assigns(:admin_crud_company))
  end

  test "should show admin_crud_company" do
    get :show, id: @admin_crud_company
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_crud_company
    assert_response :success
  end

  test "should update admin_crud_company" do
    put :update, id: @admin_crud_company, admin_crud_company: { address_line_1: @admin_crud_company.address_line_1, address_line_2: @admin_crud_company.address_line_2, ar_notes: @admin_crud_company.ar_notes, billing_to_company_id: @admin_crud_company.billing_to_company_id, city: @admin_crud_company.city, email: @admin_crud_company.email, fax: @admin_crud_company.fax, name: @admin_crud_company.name, phone: @admin_crud_company.phone, sale_id: @admin_crud_company.sale_id, state: @admin_crud_company.state, website: @admin_crud_company.website, zip_code: @admin_crud_company.zip_code }
    assert_redirected_to admin_crud_company_path(assigns(:admin_crud_company))
  end

  test "should destroy admin_crud_company" do
    assert_difference('Admin::CrudCompany.count', -1) do
      delete :destroy, id: @admin_crud_company
    end

    assert_redirected_to admin_crud_companies_path
  end
end
