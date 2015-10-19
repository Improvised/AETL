class JobTypesController < ApplicationController
  def index
    @job_types = JobType.all
    render :layout => false
  end

  def new
    @job_type = JobType.new
    render :layout => false
  end

  def create
    @job_type = JobType.new(params[:job_type])

    if @job_type.save
      render :text => 'Job type was added', :layout => false and return
    end

    render :layout => false
  end
end
