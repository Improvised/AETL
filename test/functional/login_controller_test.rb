require 'test_helper'
require 'login_controller'

class LoginController; def rescue_action(e) raise e end; end

class LoginControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  def setup
    @controller = LoginController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    @one = users(:one)
  end

  def test_index
    # success
    post :index, :user => {:username => @one.username, :password => "Aepm_admin"}
    assert_redirected_to root_path
    assert_equal @one, session[:user]

    # bad password
    post :index, :user => {:username => @one.username, :password => ""}
    assert_response :success
    assert_not_nil flash
  end

  def test_logout
    get :logout, {}, {:user => @one.id}
    assert_redirected_to root_path
    assert_nil session[:user]
  end
end
