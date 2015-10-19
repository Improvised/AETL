AETL::Application.routes.draw do

  resources :projects do
    collection do
      post 'contact_by_company'
      get 'contact_by_company_get'
      get 'search'
      # post 'auto_complete_for_project_ae_job_id'
      get "auto_complete_for_project_ae_job_id"
      get 'auto_complete_for_project_company'
    end
    member do 
      put 'create_revision'
      get 'revision'
      get 'transmittal'
      get 'job_checklist_light'
      get 'xls'
      get 'job_checklist'
      put 'update_job_status'
      put 'update_delivery_status'
    end
    resource :jobchecklists, except: [:index, :destroy] do 
      member do  
        delete 'delete_view'
      end
      collection do 
        post 'auto_complete_for__reference'  
      end
    end
  end
  
  # resources :companies, :has_many => [:contacts, :billing_to_contacts]
  resources :companies do 
    resources :contacts
    collection do
      delete 'delete_contact'
    end
  end
  # resources :client_requests, :collection => {:contact_by_company => :post}, :member => {:transmittal => :get, :job_checklist => :get}
  resources :client_requests do
    collection do 
      post 'contact_by_company'
    end
    member do 
      get 'transmittal'
      get 'job_checklist'
    end
  end

  # resources :report, :collection => {:invoice_list => :get, :do_job_scorecard => :get, :job_status => :get, :jobs_in_pre_production => :get, 
  # :jobs_to_be_invoiced => :get, :jobs_on_hold => :get, :jobs_for_po_contract => :get, :jobs_completed_wo_po => :get, :salesreport => :get}
  resources :report do
    collection do
      get 'invoice_list'
      get 'do_job_scorecard'
      get 'job_status'
      get 'jobs_in_pre_production'
      get 'jobs_to_be_invoiced'
      get 'jobs_on_hold'
      get 'jobs_for_po_contract'
      get 'jobs_completed_wo_po'
      get 'salesreport'
    end
  end

  # resources :ewazap, :collection => {:jobs_all => :get, :search => :get, :job_checklist => :get, :export_to_csv => :get}
  resources :ewazap do 
    collection do
      get 'jobs_all'
      get 'search'
      get 'job_checklist'
      get 'export_to_csv'
    end
  end
  # resources :range_search, :collection => {:index => :get, :search => :get, :job_checklist => :get, :search_export => :get, :ranger_search => :get}
  resources :range_search do 
    collection do 
      get 'index'
      get 'search'
      get 'job_checklist'
      get 'search_export'
      get 'range_search'      
    end
  end

  resources :employee_productions  
  resources :employee_project_managers
  resources :sales
  resources :job_types
  resources :handlings
  resources :travels
  resources :layouts

  resources :datasources do
    collection do 
      get 'auto_complete_for_project_company'
    end
  end
  
  namespace :admin do
    get "/" => "companies#index"
    resources :crud_companies, controller: "companies", as: :crud_companies do as_routes end
    resources :crud_account_managers, controller: "sales", as: :crud_account_managers do as_routes end
    resources :crud_contacts, controller: "contacts", as: :crud_contacts do as_routes end
    resources :crud_engineers, controller: "employee_productions", as: :crud_engineers do as_routes end
    resources :crud_handlings, controller: "handlings", as: :crud_handlings do as_routes end
    resources :crud_job_statuses, controller: "job_statuses", as: :crud_job_statuses do as_routes end
    resources :crud_job_types, controller: "job_types", as: :crud_job_types do as_routes end
    resources :crud_layouts, controller: "layouts", as: :crud_layouts do as_routes end
    resources :crud_project_managers, controller: "employee_project_managers", as: :crud_project_managers do as_routes end
    resources :crud_travels, controllers: "travels", as: :crud_travels do as_routes end
  end

  # login '/login', :controller => "login", :action => "index"
  match 'login' => 'login#index', :as => :login, via: [:get, :post]
  # logout '/logout', :controller => "login", :action => 'logout'
  match 'logout' => 'login#logout', via: [:get, :post]
  
  root to: "projects#index"

 
  # connect ':controller/:action/:id'
  # connect ':controller/:action/:id.:format'
end
