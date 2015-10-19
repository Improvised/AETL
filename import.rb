require 'rubygems'
require 'active_record'
require 'active_support'
require 'pp'

#new database
class User < ActiveRecord::Base
  establish_connection(:adapter  => "mysql" ,
    :host     => "localhost" ,
    :database => "aepm_development" ,
    :username => "root" ,
    :password => "")
end

class Company < ActiveRecord::Base
  establish_connection(:adapter  => "mysql" ,
    :host     => "localhost" ,
    :database => "aepm_development" ,
    :username => "root" ,
    :password => "")
end

#old database
class Carrier < ActiveRecord::Base
  establish_connection(:adapter  => "mysql" ,
    :host     => "localhost" ,
    :database => "aepm_tmp" ,
    :username => "root" ,
    :password => "")
end

def change_table(table, renew_table=true)
  User.table_name = table
  User.reset_column_information
  Carrier.table_name = table
  Carrier.reset_column_information
  #delete record
  if renew_table
    User.connection().execute("TRUNCATE TABLE `#{table}`;")
  end
end

def get_record(table, fields=[], renew_table=true)
  change_table(table, renew_table)
  result = []
  Carrier.all.each_with_index do |x, ind|
    hash = {}
    unless ind == 0
      Carrier.column_names.each_with_index do |f, i|
        hash[fields[i].to_sym] = eval("x.attributes['#{f}']")
      end
      result << hash
    end
  end
  return result
end

def fix_company_records(records)
  temp_records = records.dup
  result = []
  records.each do |rec|
    #sale_id
    User.table_name = 'sales'
    User.reset_column_information
    sale_rec = User.find(:first, :conditions => "name = '#{rec[:sale_id]}'")
    if sale_rec.blank?
      rec[:sale_id] = ""
    else
      rec[:sale_id] = sale_rec.id.to_s
    end

    #billing_to_company_id
    unless rec[:billing_to_company_id].blank?
      is_found = false
      temp_records.each do |x|
        if x[:name] == rec[:billing_to_company_id]
          rec[:billing_to_company_id] = x[:id]
          is_found = true
        end
      end
      rec[:billing_to_company_id] = "" unless is_found 
    end

    result << rec
  end

  User.table_name = 'companies'
  User.reset_column_information
  return result
end

def fix_projects_records(records)
  results = []
  records.each_with_index do |r, i|
    unless r[:company_id].blank?
      User.table_name = 'companies'
      User.reset_column_information
      company_rec = User.find(:first, :conditions => ["name = ?", r[:company_id]])
      unless company_rec.blank?
        r[:company_id] = company_rec.id.to_s
      else
        r[:company_id] = ""
      end
    end
    unless r[:contact_id].blank?
      User.table_name = 'contacts'
      User.reset_column_information
      rec = User.find(:first, :conditions => ["name = ? AND company_id = ?", r[:contact_id], r[:company_id]])
      unless rec.blank?
        r[:contact_id] = rec.id.to_s
      else
        r[:contact_id] = ""
      end
    end
    unless r[:job_status_id].blank?
      User.table_name = 'job_statuses'
      User.reset_column_information
      rec = User.find(:first, :conditions => ["name = ?", r[:job_status_id]])
      unless rec.blank?
        r[:job_status_id] = rec.id.to_s
      else
        r[:job_status_id] = ""
      end
    end
    unless r[:employee_project_manager_id].blank?
      User.table_name = 'employee_project_managers'
      User.reset_column_information
      rec = User.find(:first, :conditions => ["name = ?", r[:employee_project_manager_id]])
      unless rec.blank?
        r[:employee_project_manager_id] = rec.id.to_s
      else
        r[:employee_project_manager_id] = ""
      end
    end
    unless r[:employee_production_id].blank?
      User.table_name = 'employee_productions'
      User.reset_column_information
      rec = User.find(:first, :conditions => ["name = ?", r[:employee_production_id]])
      unless rec.blank?
        r[:employee_production_id] = rec.id.to_s
      else
        r[:employee_production_id] = ""
      end
    end
    unless r[:layout_id].blank?
      User.table_name = 'layouts'
      User.reset_column_information
      rec = User.find(:first, :conditions => ["name = ?", r[:layout_id]])
      unless rec.blank?
        r[:layout_id] = rec.id.to_s
      else
        r[:layout_id] = ""
      end
    end
    unless r[:billing_to_company_id].blank?
      User.table_name = 'companies'
      User.reset_column_information
      rec = User.find(:first, :conditions => ["name = ?", r[:billing_to_company_id]])
      unless rec.blank?
        r[:billing_to_company_id] = rec.id.to_s
      else
        r[:billing_to_company_id] = ""
      end
    end
    unless r[:billing_to_contact_id].blank?
      User.table_name = 'contacts'
      User.reset_column_information
      rec = User.find(:first, :conditions => ["name = ? AND company_id = ?", r[:billing_to_contact_id], r[:billing_to_company_id]])
      unless rec.blank?
        r[:billing_to_contact_id] = rec.id.to_s
      else
        r[:billing_to_contact_id] = ""
      end
    end
    unless r[:job_type_id].blank?
      User.table_name = 'job_types'
      User.reset_column_information
      rec = User.find(:first, :conditions => ["name = ?", r[:job_type_id]])
      unless rec.blank?
        r[:job_type_id] = rec.id.to_s
      else
        r[:job_type_id] = ""
      end
    end
    unless r[:handling_id].blank?
      User.table_name = 'handlings'
      User.reset_column_information
      rec = User.find(:first, :conditions => ["name = ?", r[:handling_id]])
      unless rec.blank?
        r[:handling_id] = rec.id.to_s
      else
        r[:handling_id] = ""
      end
    end
    unless r[:travel_id].blank?
      User.table_name = 'travels'
      User.reset_column_information
      rec = User.find(:first, :conditions => ["name = ?", r[:travel_id]])
      unless rec.blank?
        r[:travel_id] = rec.id.to_s
      else
        r[:travel_id] = ""
      end
    end
    unless r[:account_manager_id].blank?
      User.table_name = 'sales'
      User.reset_column_information
      rec = User.find(:first, :conditions => ["name = ?", r[:account_manager_id]])
      unless rec.blank?
        r[:account_manager_id] = rec.id.to_s
      else
        r[:account_manager_id] = ""
      end
    end
    results << r
  end
  
  User.table_name = 'projects'
  User.reset_column_information

  return results
end

def fix_contacts_records(records)
  results = []
  User.table_name = 'companies'
  User.reset_column_information
  records.each_with_index do |r, i|
    unless r[:company_id].blank?
      company_rec = User.find(:first, :conditions => ["name = ?", r[:company_id]])
      unless company_rec.blank?
        r[:company_id] = company_rec.id.to_s
      else
        r[:company_id] = ""
      end
    end
    results << r
  end
  
  User.table_name = 'contacts'
  User.reset_column_information

  return results
end

User.create(get_record('carriers', ['name']))
User.create(get_record('employee_productions', ['name']))
User.create(get_record('employee_project_managers', ['name']))
User.create(get_record('handlings', ['name']))
User.create(get_record('job_statuses', ['name']))
User.create(get_record('job_types', ['name']))
User.create(get_record('layouts', ['name', 'tabloid', 'landscape']))
User.create(get_record('sales', ['name']))
User.create(get_record('travels', ['name']))

#company
rec_companies = get_record('companies', ['name', 'id', 'address_line_1', 'address_line_2', 'city', 'state', 'zip_code', 'phone', 'fax', 'billing_to_company_id', 'sale_id'])
rec_companies = fix_company_records(rec_companies)
rec_companies.each_with_index do |y, i|
  duplicate = y.dup
  duplicate.delete(:id)
  company = User.new(duplicate)
  company.id = y[:id]
  company.save
end

#contact
rec_contacts = get_record('contacts', ['id', 'name', 'company_id', 'phone', 'fax'])
rec_contacts = fix_contacts_records(rec_contacts)
rec_contacts.each_with_index do |y, i|
  duplicate = y.dup
  duplicate.delete(:id)
  contact = User.new(duplicate)
  contact.id = y[:id]
  contact.save
end


#projcet, jobchecklist, view_jobchecklist
def filter_records(records, fields)
  results = []  
  records.each_with_index do |r, i|
    hash = {}
    fields.each_with_index do |f, j|
      hash[f.to_sym] = r[f.to_sym].to_s
    end
    results << hash
  end
  return results
end

def fix_jobchecklist_records(records)
  results = []
  records.each_with_index do |r, i|
    unless r[:ae_job_id].blank?
      User.table_name = 'projects'
      User.reset_column_information
      rec = User.find(:first, :conditions => ["ae_job_id = ?", r[:ae_job_id]])
      unless rec.blank?
        r[:project_id] = rec.id.to_s
      else
        r[:project_id] = ""
      end
    end
    unless r[:carrier_id].blank?
      User.table_name = 'carriers'
      User.reset_column_information
      rec = User.find(:first, :conditions => ["name = ?", r[:carrier_id]])
      unless rec.blank?
        r[:carrier_id] = rec.id.to_s
      else
        r[:carrier_id] = ""
      end
    end
    results << r.delete_if {|k,v| k == :ae_job_id}
  end
  
  User.table_name = "jobchecklists"
  User.reset_column_information

  return results
end

def fix_view_jobchecklist_records(records)
  results = []
  User.table_name = 'jobchecklists'
  User.reset_column_information
  records.each_with_index do |r, i|
    unless r[:ae_job_id].blank?
      rec = User.find(:first, :conditions => ["projects.ae_job_id = ?", r[:ae_job_id]], :joins => "INNER JOIN projects ON project_id = projects.id")
      unless rec.blank?
        r[:jobchecklist_id] = rec.id.to_s
      else
        r[:jobchecklist_id] = ""
      end
    end
    results << r.delete_if {|k,v| k == :ae_job_id}
  end
  
  User.table_name = "view_jobchecklists"
  User.reset_column_information

  return results
end

def fix_date_in_and_due_date(records)
  # m/d/y
  results = []
  records.each_with_index do |r, i|
    unless r[:date_in].empty?
      date_in = r[:date_in].split("/")
      r[:date_in] = Time.mktime(date_in[2], date_in[0], date_in[1]).to_date
    end

    unless r[:due_date].empty?
      due_date = r[:due_date].split("/")
      r[:due_date] = Time.mktime(due_date[2], due_date[0], due_date[1]).to_date
    end

    results << r
  end
  return results
end


#fields
fields = ['ae_job_id', 'name', 'number', 'notes', 'company_id', 'contact_id', 'date_in', 'xxtime_in', 'due_date', 'job_status_id', 'employee_project_manager_id', 'employee_production_id', 'address_line_1', 'address_line_2', 'city', 'state', 'zip', 'layout_id', 'number_of_copies', 'time_of_day_shot', 'project_manager_hour', 'mileage', 'production_hour', 'nov', 'xxxbllin_status', 'job_description', 'carrier_id', 'v1_description', 'v2_description', 'v3_description', 'v4_description', 'v5_description', 'v6_description', 'v7_description', 'v8_description', 'v9_description', 'v10_description', 'xxcontact2', 'xxcontact2_prints', 'billing_note', 'xxactive', 'xxdate_finished', 'xxbilling_note', 'billing_to_company_id', 'billing_to_contact_id', 'price', 'invoice_number', 'job_type_id', 'job_history', 'handling_id', 'travel_id', 'account_manager_id']

project_fields = ['ae_job_id', 'name', 'number', 'address_line_1', 'address_line_2', 'city', 'state', 'zip', 'company_id', 'contact_id', 'account_manager_id', 'date_in', 'due_date', 'job_status_id', 'production_hour', 'mileage', 'employee_project_manager_id', 'employee_production_id', 'project_manager_hour', 'job_type_id', 'handling_id', 'travel_id', 'billing_note', 'billing_to_company_id', 'billing_to_contact_id', 'price', 'invoice_number',  'job_history']

jobchecklist_fields = ['ae_job_id', 'project_id', 'carrier_id', 'employee_project_manager_id', 'job_description', 'number_of_copies', 'layout_id', 'notes']

view_jobchecklist_fields = ['ae_job_id', 'jobchecklist_id', 'v1_description', 'v2_description', 'v3_description', 'v4_description', 'v5_description', 'v6_description', 'v7_description', 'v8_description', 'v9_description', 'v10_description', 'notes', 'time_of_day_shot']


records = get_record('projects', fields)
records = fix_projects_records(records)
#records = fix_date_in_and_due_date(records)

#project
project_records = filter_records(records, project_fields)
User.create(project_records)

#jobchecklist
#jobchecklist_records = filter_records(records, jobchecklist_fields)
#jobchecklist_records = fix_jobchecklist_records(jobchecklist_records)
#User.create(jobchecklist_records)

#view_jobchecklist
#view_jobchecklist_records = filter_records(records, view_jobchecklist_fields)
#view_jobchecklist_records = fix_view_jobchecklist_records(view_jobchecklist_records)

#view_jobchecklist_records.each do |r|
#  1.upto(10) do |i|
#    unless r["v#{i}_description".to_sym].blank?
#      view_jobchecklist = User.new
#      view_jobchecklist.jobchecklist_id = r[:jobchecklist_id]
#      view_jobchecklist.view = r["v#{i}_description".to_sym]
#      view_jobchecklist.notes = r[:notes] if false
#      view_jobchecklist.time_of_day_shot = r[:notes]
#      view_jobchecklist.save
#    end
#  end
#end

def fix_client_requests_records(records)
  results = []
  records.each_with_index do |r, i|
    unless r[:project_id].blank?
      r = r.merge({:reference_ae_job_id => r[:project_id]})
      User.table_name = 'projects'
      User.reset_column_information
      ae_job_id = r[:project_id].slice(0, 9)
      rec = User.find(:first, :conditions => ["ae_job_id LIKE ?", "%" + ae_job_id + "%"])
      unless rec.blank?
        r[:project_id] = rec.id.to_s
      else
        r[:project_id] = ""
      end
    end
    unless r[:job_type_id].blank?
      User.table_name = 'job_types'
      User.reset_column_information
      rec = User.find(:first, :conditions => ["name = ?", r[:job_type_id]])
      unless rec.blank?
        r[:job_type_id] = rec.id.to_s
      else
        r[:job_type_id] = ""
      end
    end
    unless r[:contact_id].blank?
      User.table_name = 'contacts'
      User.reset_column_information
      rec = User.find(:first, :conditions => ["name = ?", r[:contact_id]])
      unless rec.blank?
        r[:contact_id] = rec.id.to_s
      else
        r[:contact_id] = ""
      end
    end
    unless r[:job_status_id].blank?
      User.table_name = 'job_statuses'
      User.reset_column_information
      rec = User.find(:first, :conditions => ["name = ?", r[:job_status_id]])
      unless rec.blank?
        r[:job_status_id] = rec.id.to_s
      else
        r[:job_status_id] = ""
      end
    end
    unless r[:billing_to_contact_id].blank?
      User.table_name = 'contacts'
      User.reset_column_information
      rec = User.find(:first, :conditions => ["name = ?", r[:billing_to_contact_id]])
      unless rec.blank?
        r[:billing_to_contact_id] = rec.id.to_s
      else
        r[:billing_to_contact_id] = ""
      end
    end
    unless r[:billing_to_company_id].blank?
      User.table_name = 'companies'
      User.reset_column_information
      rec = User.find(:first, :conditions => ["name = ?", r[:billing_to_company_id]])
      unless rec.blank?
        r[:billing_to_company_id] = rec.id.to_s
      else
        r[:billing_to_company_id] = ""
      end
    end
    unless r[:company_id].blank?
      User.table_name = 'companies'
      User.reset_column_information
      company_rec = User.find(:first, :conditions => ["name = ?", r[:company_id]])
      unless company_rec.blank?
        r[:company_id] = company_rec.id.to_s
      else
        r[:company_id] = ""
      end
    end
    unless r[:travel_id].blank?
      User.table_name = 'travels'
      User.reset_column_information
      rec = User.find(:first, :conditions => ["name = ?", r[:travel_id]])
      unless rec.blank?
        r[:travel_id] = rec.id.to_s
      else
        r[:travel_id] = ""
      end
    end
    unless r[:handling_id].blank?
      User.table_name = 'handlings'
      User.reset_column_information
      rec = User.find(:first, :conditions => ["name = ?", r[:handling_id]])
      unless rec.blank?
        r[:handling_id] = rec.id.to_s
      else
        r[:handling_id] = ""
      end
    end
    unless r[:employee_production_id].blank?
      User.table_name = 'employee_productions'
      User.reset_column_information
      rec = User.find(:first, :conditions => ["name = ?", r[:employee_production_id]])
      unless rec.blank?
        r[:employee_production_id] = rec.id.to_s
      else
        r[:employee_production_id] = ""
      end
    end
    unless r[:account_manager_id].blank?
      User.table_name = 'sales'
      User.reset_column_information
      rec = User.find(:first, :conditions => ["name = ?", r[:account_manager_id]])
      unless rec.blank?
        r[:account_manager_id] = rec.id.to_s
      else
        r[:account_manager_id] = ""
      end
    end
    results << r
  end

  User.table_name = 'client_requests'
  User.reset_column_information

  return results
end

#client_requests
#field_client_requests = ['cr_job_id', 'project_note', 'trans_desc', 'project_id', 'date_in', 'due_date', 'project_name', 'project_number', 'job_type_id', 'contact_id', 'company_id', 'job_status_id', 'xxactive', 'billing_to_contact_id', 'billing_to_company_id', 'xxxbilling_status', 'purchase_order', 'invoice', 'price', 'xxxcompany_id', 'travel_id', 'handling_id', 'employee_production_id', 'production_hour', 'date_finished', 'account_manager_id']
#client_requests_fields = ['cr_job_id', 'project_note', 'trans_desc', 'project_id', 'date_in', 'due_date', 'project_name', 'project_number', 'job_type_id', 'contact_id', 'job_status_id', 'billing_to_contact_id', 'billing_to_company_id', 'purchase_order', 'invoice', 'price', 'company_id', 'travel_id', 'handling_id', 'employee_production_id', 'production_hour', 'date_finished', 'account_manager_id', 'reference_ae_job_id']
#rec_client_requests = get_record('client_requests', field_client_requests)
#rec_client_requests = fix_client_requests_records(rec_client_requests)
#client_requests_records = filter_records(rec_client_requests, client_requests_fields)
#User.create(client_requests_records)

puts "Done..."