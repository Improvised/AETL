class JobchecklistsController < ApplicationController
  before_filter :prepare_project
  before_filter :prepare_data

  def index
  end

  def new
    @jobchecklist = Jobchecklist.new
    #set default
    @jobchecklist.employee_project_manager_id = @project.employee_project_manager_id
    @jobchecklist.layout_id = Layout.default
  end

  def create
    @jobchecklist = Jobchecklist.new(params[:jobchecklist])
    @project.jobchecklist = @jobchecklist
    @view_jobchecklists = []
    params[:view][:view].each_with_index do |x, i|
    # params[:view].each_with_index do |x, i|
      if !(x.blank? && params[:view][:notes][i].blank? && params[:view][:time_of_day_shot][i].blank? && params[:view][:field_of_view][i].blank?)
        # time_of_day_shot = params[:view][:time_of_day_shot][i]
        time_of_day_shot = Chronic.parse(params[:view][:time_of_day_shot][i])
        @view_jobchecklists << ViewJobchecklist.new({:view => x, :notes => params[:view][:notes][i], :time_of_day_shot => time_of_day_shot, :field_of_view => params[:view][:field_of_view][i]})
      end
    end
    @jobchecklist.views = @view_jobchecklists

    if @project.save
      flash[:message] = 'Jobchecklist was added'
      redirect_to edit_project_jobchecklists_path(@project) and return
    end
    render :action => :new
  end

  def edit
    @jobchecklist = @project.jobchecklist
    @view_jobchecklists = @jobchecklist.views
  rescue
    redirect_to projects_path
  end

  def update
    @jobchecklist = @project.jobchecklist
    @view_jobchecklists = []
    params[:view][:view].each_with_index do |x, i|
      if !(x.blank? && params[:view][:notes][i].blank? && params[:view][:time_of_day_shot][i].blank? && params[:view][:field_of_view][i].blank?)
        time_of_day_shot = Chronic.parse(params[:view][:time_of_day_shot][i])
        @view_jobchecklists << ViewJobchecklist.new({:view => x, :notes => params[:view][:notes][i], :time_of_day_shot => time_of_day_shot, :field_of_view => params[:view][:field_of_view][i]})
      end
    end
    if @jobchecklist.update_attributes(params[:jobchecklist])
      @jobchecklist.views.delete_all
      @jobchecklist.views = @view_jobchecklists

      flash[:message] = 'Project was updated'
      redirect_to edit_project_jobchecklists_path(@project) and return
    end
    render :action => :edit
  end

  def delete_view
    ViewJobchecklist.find(params[:id]).destroy unless params[:id].blank?
    redirect_to edit_project_jobchecklists_path(@project) and return
  end

 private
  def prepare_data
    @employee_project_managers = EmployeeProjectManager.all
    @carriers = Carrier.all
    @layouts = Layout.all
    @view_jobchecklists = []
  end

  def prepare_project
    @project = Project.find(params[:project_id], :include => [:jobchecklist]) unless params[:project_id].blank?
  end
end
