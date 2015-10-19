class TravelsController < ApplicationController
  def index
    @travels = Travel.all
    render :layout => false
  end

  def new
    @travel = Travel.new
    render :layout => false
  end

  def create
    @travel = Travel.new(params[:travel])

    if @travel.save
      render :text => 'Travel was added', :layout => false and return
    end

    render :layout => false
  end
end
