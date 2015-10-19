class Admin::CrudContactsController < Admin::AdminController
  active_scaffold :contact do |config|
    config.columns = ['name', 'company', 'phone', 'fax', 'email']
    config.columns['company'].form_ui = :select
  end
end
