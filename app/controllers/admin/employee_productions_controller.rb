class Admin::EmployeeProductionsController < ApplicationController
  active_scaffold :"employee_production" do |conf|
  	conf.columns = [:name]
  end
end
