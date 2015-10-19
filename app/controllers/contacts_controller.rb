class ContactsController < ApplicationController
  before_filter :find_company

  def index
    @contacts = @company.contacts
    # render :layout => false
  end

  def new
    @html_id = params[:html_id]
    # @company_id = params[:company_id]
    @contact = @company.contacts.new
    render :layout => false
  end

  def create
    @html_id = params[:html_id]
    # @company = Company.find(params[:company_id])
    @contact = @company.contacts.new(params[:contact])

    if @contact.save
      # render :text => 'Contact was added', :layout => false and return
      @message = 'Contact was added!'
    else
      @message = 'Contact fail added!'
    end
    # render :layout => false
    respond_to :js
  end

  private
  def find_company
    @company = Company.find(params[:company_id])
  end
end