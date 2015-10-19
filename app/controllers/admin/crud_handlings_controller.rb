class Admin::CrudHandlingsController < Admin::AdminController
  active_scaffold :handling do |config|
     config.columns = ['name']
  end
end
