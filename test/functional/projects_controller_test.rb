require 'test_helper'
require 'projects_controller'

class ProjectsController; def rescue_action(e) raise e end; end

class ProjectsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  def setup
    @controller = ProjectsController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    @one = projects(:one)
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
    assert_difference('Project.count') do
      post :create, :project => {:ae_job_id => Project.new.create_ae_job_id}
    end

    assert_redirected_to projects_path
    assert_equal "Project was added", flash[:message]
  end

  def test_should_update_record
    put :update, :id => @one.to_param, :project => {:ae_job_id => @one.ae_job_id}
    assert_redirected_to projects_path
    assert_equal "Project was updated", flash[:message]
  end

  def test_should_destroy_record
    assert_difference('Project.count', -1) do
      post :destroy, :id => @one.to_param
    end

    assert_redirected_to projects_path
    assert_equal "Project was deleted", flash[:message]
  end
end
