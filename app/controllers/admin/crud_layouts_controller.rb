class Admin::CrudLayoutsController < Admin::AdminController
  active_scaffold :layouts do |config|
     config.columns = ['name', 'tabloid', 'landscape']
  end
end
