class Admin::LayoutsController < ApplicationController
  active_scaffold :layout do |conf|
  	conf.columns = [:name, :tabloid, :landscape]
  end
end
