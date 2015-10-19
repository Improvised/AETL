class BillingToContactsController < ApplicationController
  before_filter :find_company

  def index
    @contacts = @company.contacts
    render :layout => false
  end

  def new
    @contact = @company.contacts.new
    render :layout => false
  end

  def create
    @contact = @company.contacts.new(params[:contact])

    if @contact.save
      render :text => 'Billing to Contact was added', :layout => false and return
    end

    render :layout => false
  end

  private
  def find_company
    @company = Company.find(params[:company_id])
  end
end