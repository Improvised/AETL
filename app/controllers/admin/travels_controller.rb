class Admin::TravelsController < ApplicationController
  active_scaffold :travel do |conf|
  	conf.columns = [:name]
  end
end
