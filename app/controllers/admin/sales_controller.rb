class Admin::SalesController < ApplicationController
  active_scaffold :sale do |conf|
  	conf.columns = ['name']
  end
end
