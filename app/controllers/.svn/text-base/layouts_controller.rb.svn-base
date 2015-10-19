class LayoutsController < ApplicationController
  def index
    @layouts = Layout.all
    render :layout => false
  end

  def new
    @layout = Layout.new
    render :layout => false
  end

  def create
    @layout = Layout.new(params[:layout])

    if @layout.save
      render :text => 'Layout was added', :layout => false and return
    end

    render :layout => false
  end
end
