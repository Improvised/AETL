class HandlingsController < ApplicationController
  def index
    @handlings = Handling.all
    render :layout => false
  end

  def new
    @handling = Handling.new
    render :layout => false
  end

  def create
    @handling = Handling.new(params[:handling])

    if @handling.save
      render :text => 'Handling was added', :layout => false and return
    end

    render :layout => false
  end
end
