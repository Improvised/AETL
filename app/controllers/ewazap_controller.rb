class EwazapController < ApplicationController 
skip_before_filter :check_session
before_filter :check_session_ewa

  
  def index    
    @jobs_all = Project.order("id DESC").paginate :page => params[:page], :per_page => 100
    @jobs_aller = Project.order("id DESC")
    @alljsize = @jobs_aller.size
  end
  
  def search
    @jobs_aller = Project.order("id DESC")
    @alljsize = @jobs_aller.size
    params[:field] = "All Fields"
    @all_projects = Project.search_ewa(params)
    @jobs_all = @all_projects.paginate :page => params[:page], :per_page => 100
    render :action => 'index'

  end
  
  def export_to_csv 
    @jobs_all = Project.order("id DESC").paginate :page => params[:page], :per_page => 500 
    csv_string = CSV.generate do |csv| 
      # header row 
      csv << ["AE Job ID", "Job Name", "Project Number", "City", "Carrier", "Full Address", "Job Type", "Job Description"] 
 
      # data rows 
      @jobs_all.each do |job|         
        @clist_car_name = job.jobchecklist.carrier.name if (!job.jobchecklist.blank? && !job.jobchecklist.carrier.blank?)
        @clist_job_desc = job.jobchecklist.job_description if (!job.jobchecklist.blank? && !job.jobchecklist.job_description.blank?)
        @jobs_type_name = job.job_type.name unless job.job_type.blank?
        
        csv << [job.ae_job_id, job.name, job.number, job.city, @clist_car_name, job.address_line_1,  @jobs_type_name, @clist_job_desc] 
      end 
    end 
 
    # send it to the browsah
    send_data csv_string, 
            :type => 'text/csv; charset=iso-8859-1; header=present', 
            :disposition => "attachment; filename=users.csv" 
  end
  
  
  
end
