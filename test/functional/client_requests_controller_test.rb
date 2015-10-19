require 'test_helper'
require 'client_requests_controller'

class ClientRequestsController; def rescue_action(e) raise e end; end

class ClientRequestsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  def setup
    @controller = ClientRequestsController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    @one = client_requests(:one)
    session[:user] = users(:one).username
  end

  def test_should_show_index
    get :index
    assert_response :success
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
    assert_difference('ClientRequest.count') do
      post :create, :client_request => {}
    end

    assert_redirected_to client_requests_path
    assert_equal "Client request was created", flash[:message]
  end

  def test_should_update_record
    put :update, :id => @one.to_param, :client_request => {}
    assert_redirected_to client_requests_path
    assert_equal "Client request was updated", flash[:message]
  end

  def test_should_destroy_record
    assert_difference('ClientRequest.count', -1) do
      delete :destroy, :id => @one.to_param
    end

    assert_redirected_to client_requests_path
    assert_equal "Client request deleted succesfully", flash[:message]
  end

  def test_search
    post :search, :find_what => @one.ae_job_id, :look_in => "AE Job ID", :match => "Any Part of Field", :commit => "Find"
    assert_not_nil assigns(:client_requests)
    assert_equal @one.ae_job_id, assigns(:client_requests).first.ae_job_id
    assert assigns(:client_requests).first.valid?
  end
end