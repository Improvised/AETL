class Admin::CompaniesController < ApplicationController
  active_scaffold :company do |conf|
  	conf.columns =[:name, :address_line_1, :address_line_2, :city, :state, :zip_code, :company, :phone, :fax, :sale, :website, :email]
  	# conf.columns = ['name', 'address_line_1', 'address_line_2', 'city', 'state', 'zip_code', 'company', 'phone', 'fax', 'sale', 'website', 'email']
    # config.create.columns = ['name', 'address_line_1', 'address_line_2', 'city', 'state', 'zip_code', 'company', 'phone', 'fax', 'sale', 'website', 'email']
    conf.columns['sale'].form_ui = :select
    conf.columns['company'].label = "Billing to Company"
    conf.columns['company'].form_ui = :select
  end
end
