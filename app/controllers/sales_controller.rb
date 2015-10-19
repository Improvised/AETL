class SalesController < ApplicationController
  def index
    @sales = Sale.all
    render :layout => false
  end

  def new
    @sale = Sale.new
    # render :layout => false
    respond_to do |format|
      format.js
    end
  end

  def create    
    # @sale = Sale.new(params[:sale])
    # if @sale.save
    #   render :text => 'Account manager was added', :layout => false and return
    # end
    # render :layout => false

    @sale = Sale.new(params[:sale])
    @message = if @sale.save
      'Account manager was added'
    else
      'Account manager fail added'
    end

    respond_to do |format|
      format.js
    end
  end  
  
end
