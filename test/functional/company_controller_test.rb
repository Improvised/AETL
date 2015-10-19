require 'test_helper'
require 'companies_controller'

class CompaniesController; def rescue_action(e) raise e end; end

class CompanyControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  def setup
    @controller = CompaniesController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    @one = companies(:one)
    session[:user] = users(:one).username
  end

  def test_should_show_index
    get :index
    assert_response :success
    assert_not_nil assigns(:companies)
  end

  def test_should_show_edit_form
    get :edit, :id => @one.to_param
    assert_response :success
  end

  def test_should_show_new_form
    get :new
    assert_response :success
  end

  def test_should_add_new_record
    assert_difference('Company.count') do
      post :create, :company => {:name => @one.name + "a", :sale_id => @one.sale_id}, :contact => {:name => [contacts(:one).name], :phone => [contacts(:one).phone], :fax => [contacts(:one).fax], :email => [contacts(:one).email]}
    end

    assert_redirected_to companies_path
    assert_equal "Company created succesfully", flash[:message]
  end

  def test_should_update_record
    put :update, :id => @one.to_param, :company => {:name => @one.name, :sale_id => @one.sale_id}, :contact => {:name => [contacts(:one).name], :phone => [contacts(:one).phone], :fax => [contacts(:one).fax], :email => [contacts(:one).email]}
    assert_redirected_to companies_path
    assert_equal "Company updated succesfully", flash[:message]
  end

  def test_should_destroy_record
    assert_difference([ 'Company.count', 'Contact.count' ], -1) do
      delete :destroy, :id => @one.to_param
    end

    assert_redirected_to companies_path
    assert_equal "Company deleted succesfully", flash[:message]
  end
end
