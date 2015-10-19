class Admin::CrudCompaniesController < ApplicationController
  active_scaffold :"company" do |conf|
  end
end
