class Admin::AdminController < ApplicationController
  before_filter :check_status_user
  ActiveScaffold.set_defaults do |config| 
    config.ignore_columns.add [:created_at, :updated_at]
  end
  
  protected
  def check_status_user
    if !session[:user].blank? && session[:user][:status] != "ADMIN"
      redirect_to root_url
    end
  end
end
