class Admin::HandlingsController < ApplicationController
  active_scaffold :handling do |conf|
  	conf.columns = [:name]
  end
end
