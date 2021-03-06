class ReportController < ApplicationController  
  def index
  end

  def job_status    
    @jobs_in_production = Project.prepare_project("In Production", "=")
    @jobs_active = Project.prepare_project("Invoiced", "!=")
    jobs_in_pre_production
    jobs_to_be_invoiced
    jobs_on_hold
    jobs_for_po_contract
    jobs_completed_wo_po
  end

  def job_scorecard
    @companies = Company.all(:order => 'name')
    @contacts = []
  end

  def do_job_scorecard
    @all_projects = Project.job_scorecard(params)
    @projects = @all_projects.paginate :page => params[:page] || 1, :per_page => COUNT_PER_PAGE

    @contacts = []
    render :layout => false
  end

  def invoice_list
#    @client_requests = ClientRequest.all(:include => [:travel, :handling, :job_type, :contact, :company, :billing_to_company, :billing_to_contact], :order => 'cr_job_id', :joins => "INNER JOIN job_statuses ON client_requests.job_status_id = job_statuses.id ", :conditions => ["job_statuses.name = 'To Be Invoiced'"])
    jobs_to_be_invoiced
    
    if (@jobs_to_be_invoiced.size%7) == 0
      @jobs_to_be_invoiced_pages =  @jobs_to_be_invoiced.size/7
    else
      @jobs_to_be_invoiced_pages =  (@jobs_to_be_invoiced.size/7) + 1
    end
            
#    @all_reports = @client_requests + @jobs_to_be_invoiced  
    
    @all_reports = @jobs_to_be_invoiced
    render :layout => false    
  end

  def contact_by_company
    @contacts = Contact.find_all_by_company_id(params[:id])
    render :layout => false
  rescue
    @contacts = []
    render :layout => false
  end

  def jobs_in_pre_production
    @jobs_in_pre_production = Project.prepare_project("In Pre-Production", "=")
  end

  def jobs_to_be_invoiced
    @jobs_to_be_invoiced_pre1 = Project.prepare_project_antdesc("To Be Invoiced", "=")    
    @jobs_to_be_invoiced = @jobs_to_be_invoiced_pre1.all(:joins => :jobchecklist, :order => 'billing_to_company_id, billing_to_contact_id, jobchecklists.carrier_id DESC')
    
  end

  def jobs_on_hold
    @jobs_on_hold = Project.prepare_project("On Hold", "=")
  end
    
  def jobs_for_po_contract
    @jobs_for_po_contract = Project.prepare_project("Waiting for PO / Contract", "=")
  end

  def jobs_completed_wo_po
    @jobs_completed_wo_po = Project.prepare_project("W/O PO--Completed", "=")
  end
  
  def salesreport
    time = Time.now
    set_nfo = time.year
    @salesreport = Project.prepare_project("All Jobs", "!=").paginate :page => params[:page], :per_page => 100, :conditions => ["ae_job_id LIKE ?", "%#{set_nfo}%"], :order => :ae_job_id    
  end

end