class ClientRequestsController < ApplicationController
  before_filter :prepare_data, :except => [:index, :contact_by_company]
  skip_before_filter :verify_authenticity_token, :only => [:auto_complete_for_client_request_reference]

  def index
    @client_requests = ClientRequest.paginate :page => params[:page] || 1, :per_page => COUNT_PER_PAGE, :order => 'cr_job_id DESC'
  end

  def search
    @all_client_requests = ClientRequest.search(params)
    @client_requests = @all_client_requests.paginate :page => params[:page], :per_page => COUNT_PER_PAGE

    render :action => 'index'
  end

  def show
    edit
  end

  def new
    @client_request = ClientRequest.new
    #set default
    @client_request.handling_id = Handling.default
    @client_request.travel_id = Travel.default
    @client_request.date_in = Time.now
  end

  def create
    params[:client_request] = fix_format_date(params[:client_request])
    @client_request = ClientRequest.new(params[:client_request])

    if @client_request.save
      flash[:message] = "Client request was created"
      redirect_to :action => 'index' and return
    end

    prepare_data
    @contacts = Contact.find_all_by_company_id(@client_request.company_id) unless @client_request.company_id.blank?
    render :action => 'new'
  end

  def edit
    @client_request = ClientRequest.find(params[:id])
    @contacts = Contact.find_all_by_company_id(@client_request.company_id) unless @client_request.company_id.blank?
    @billing_to_contacts = Contact.find_all_by_company_id(@client_request.billing_to_company_id) and @billing_to_contacts << Contact.find_by_name("Accounts Payable") unless @client_request.billing_to_company_id.blank?
  end

  def update
    params[:client_request] = fix_format_date(params[:client_request])
    @client_request = ClientRequest.find(params[:id])

    if @client_request.update_attributes(params[:client_request])
      flash[:message] = 'Client request was updated'
      redirect_to edit_client_request_path(@client_request) and return
    end
    
    prepare_data
    @contacts = @client_request.company.contacts unless @client_request.company.blank?
    render :action => 'edit', :id => params[:id]
  end

  def destroy
    ClientRequest.find(params[:id]).destroy
    flash[:message] = 'Client request deleted succesfully'
    redirect_to :action => 'index'
  end

  def contact_by_company
    @contacts = Contact.find_all_by_company_id(params[:id])
    render :layout => false
  rescue
    @contacts = []
    render :layout => false
  end

  def auto_complete_for__reference
    search = params[:reference]
    @projects = Project.where(["cr_job_id LIKE ?", "%" + search + "%"]).limit(20)
    render :partial => "client_request_reference"
  end

  def auto_complete_for_client_request_ae_job_id
    search = params[:client_request][:ae_job_id]
    @client_requests = ClientRequest.where(["cr_job_id LIKE ?", "%" + search + "%"]).limit(20)
    render :partial => "client_request_ae_job_id"
  end

  def job_checklist
    @client_request = ClientRequest.find(params[:id], :include => [:project => [:contacts, :billing_to_contacts]])
    @project = @client_request.project
    @i = (!params[:page].nil? ? (params[:page].to_i - 1) : 0) * 10
    @views = ViewJobchecklist.paginate :page => params[:page] || 1, :per_page => 5, :conditions => ["jobchecklist_id = ?", @project.jobchecklist.id] unless @project.jobchecklist.nil?
    render :layout => false
  end

  def transmittal
    @client_request = ClientRequest.find(params[:id])
    render :layout => false
  end

  private
    def prepare_data
      @companies = Company.order(:name)
      @contacts = []
      @billing_to_contacts = []
      @job_statuses = JobStatus.order(:name)
      @sales = Sale.order(:name)
      @job_types = ClientRequestJobType.order(:name)
      @handlings = Handling.order(:name)
      @travels = Travel.order(:name)
      @employee_productions = EmployeeProduction.all
      @employee_project_managers = EmployeeProjectManager.all
    end
end
