require 'test_helper'
require 'home_controller'

class HomeController; def rescue_action(e) raise e end; end

class HomeControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  def setup
    @controller = HomeController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    @one = users(:one)
  end

  def test_index
    # without user
    get :index
    assert_redirected_to login_url

    # with user
    get :index, {}, {:user => @one.username}
    assert_response :success
    assert_template "index"
  end
end
