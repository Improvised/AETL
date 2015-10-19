class RangeSearchController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:auto_complete_for_project_ae_job_id, :auto_complete_for_project_company, :auto_complete_for_project_billing_to_company]

  def index
    @report_start_date = 1.year.ago
    @report_end_date = 0.days.ago
    @report_start_date1 = @report_start_date - 1.day
    @projects_prep = Project.where(['due_date >= ? and due_date <= ?', @report_start_date1, @report_end_date]).order('due_date, ae_job_id')
    @projects = @projects_prep.paginate :page => params[:page], :per_page => COUNT_PER_PAGE
    
  end
    

  
  def search
    @report_start_date = build_date_from_params("start_date", params[:report])
    @report_end_date = build_date_from_params("end_date", params[:report])    
    @projects_prep = Project.where(['due_date >= ? and due_date <= ?', @report_start_date, @report_end_date]).order('due_date, ae_job_id')
    @projects = @projects_prep.paginate :page => params[:page], :per_page => COUNT_PER_PAGE    
    render :action => 'index'
     
  end
  
  
  def search_export    
    @report_start_date = build_date_from_params("start_date", params[:report])
    @report_end_date = build_date_from_params("end_date", params[:report])    
    @projects = Project.where(['due_date >= ? and due_date <= ?', @report_start_date, @report_end_date]).order('due_date, ae_job_id')
      
    csv_string = CSV.generate do |csv|
      # header row 
      csv << ["AE Job ID", "Project Name", "Project Number", "Due Date", "Carrier", "Company Name", "Contact", "Status"] 
 
      # data rows 
      @projects.each do |job|         
        @clist_car_name = job.jobchecklist.carrier.name if (!job.jobchecklist.blank? && !job.jobchecklist.carrier.blank?)
        @jobs_comp_name = job.company.name unless job.company.blank?
        @jobs_cont_name = job.contact.name unless job.contact.blank?
        
        
        csv << [job.ae_job_id, job.name, job.number, job.due_date, @clist_car_name, @jobs_comp_name, @jobs_cont_name, job.job_status.name] 
      end 
    end 
   
    # send it to the browsah
    send_data csv_string, 
            :type => 'text/csv; charset=iso-8859-1; header=present', 
            :disposition => "attachment; filename=range_search.csv" 
  end
  
 
  
  def build_date_from_params(field_name, params)
    Date.new(params["#{field_name.to_s}(1i)"].to_i, 
       params["#{field_name.to_s}(2i)"].to_i, 
       params["#{field_name.to_s}(3i)"].to_i)
  end
 
end