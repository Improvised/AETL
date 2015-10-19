class Admin::CrudProjectManagersController < Admin::AdminController
  active_scaffold :employee_project_manager do |config|
     config.columns = ['name']
  end
end
