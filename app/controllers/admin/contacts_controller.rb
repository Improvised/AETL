class Admin::ContactsController < ApplicationController
  active_scaffold :"contact" do |conf|
  	conf.columns = ['name', 'company', 'phone', 'fax', 'email']
  	conf.columns['company'].form_ui = :select
  end
end
