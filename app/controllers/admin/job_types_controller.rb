class Admin::JobTypesController < ApplicationController
  active_scaffold :job_type do |conf|
  	conf.columns = [:name]
  end
end
