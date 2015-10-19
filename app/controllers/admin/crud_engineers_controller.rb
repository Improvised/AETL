class Admin::CrudEngineersController < Admin::AdminController
  active_scaffold :employee_production do |config|
     config.columns = ['name']
  end
end
