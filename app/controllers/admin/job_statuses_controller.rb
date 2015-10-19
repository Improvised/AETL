class Admin::JobStatusesController < ApplicationController
  active_scaffold :"job_status" do |conf|
  	conf.columns = [:name]
  end
end
