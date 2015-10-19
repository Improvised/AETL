class Admin::EmployeeProjectManagersController < ApplicationController
  active_scaffold :"employee_project_manager" do |conf|
  	conf.columns = ['name']
  end
end
