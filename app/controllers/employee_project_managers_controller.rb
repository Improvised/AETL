class EmployeeProjectManagersController < ApplicationController
  def index
    @employee_project_managers = EmployeeProjectManager.all
    render :layout => false
  end

  def new
    @employee_project_manager = EmployeeProjectManager.new
    # render :layout => false
    respond_to :js
  end

  def create
    @employee_project_manager = EmployeeProjectManager.new(params[:employee_project_manager])
    # if @employee_project_manager.save
    #   render :text => 'Project Manager was added', :layout => false and return
    # end
    # render :layout => false

    @message = if @employee_project_manager.save
      'Project Manager was added'
    else
      'Project Manager fail added'
    end
    respond_to :js
  end
end
