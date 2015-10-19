class EmployeeProductionsController < ApplicationController
  def index
    @employee_productions = EmployeeProduction.all
    render :layout => false
  end

  def new
    @employee_production = EmployeeProduction.new
    # render :layout => false
    respond_to :js
  end

  def create
    # @employee_production = EmployeeProduction.new(params[:employee_production])
    # if @employee_production.save
    #   render :text => 'Engineer was added', :layout => false and return
    # end
    # render :layout => false
    
    @employee_production = EmployeeProduction.new(params[:employee_production])
    @message = if @employee_production.save
      'Engineer was added'
    else
      'Engineer fail added'
    end

    respond_to do |format|
      format.js
    end
  end
end
