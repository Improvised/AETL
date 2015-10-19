class ClientRequest < ActiveRecord::Base
  
  attr_accessible :cr_job_id, :project_note, :trans_desc, :project_id, :date_in, :due_date, :project_name, :project_number,
   :client_request_job_type_id, :contact_id, :company, :job_status_id, :active, :billing_to_contact_id, 
   :billing_to_company_id, :purchase_order, :invoice, :price, :company_id, :travel_id, :handling_id, 
   :employee_production_id, :production_hour, :date_finished, :account_manager_id, :reference_ae_job_id


  belongs_to :travel
  belongs_to :handling
  belongs_to :client_request_job_type
  belongs_to :contact
  belongs_to :company
  belongs_to :billing_to_company, :class_name => "Company"
  belongs_to :billing_to_contact, :class_name => "Contact"
  belongs_to :project

  def create_cr_job_id
    number = "0"
    # client_request_rec = ClientRequest.find(:last)
    client_request_rec = ClientRequest.last
    unless client_request_rec.blank?
      last_cr_job_id = client_request_rec.cr_job_id
      year = last_cr_job_id.split("-")[1]
      number = last_cr_job_id.split("-")[2]
    end
    number = "0" if year.to_i != Time.now.year

    cr_job_id = "CR-" + Time.now.year.to_s + "-" + ("0" * (4 - number.to_i.to_s.size)) + (number.to_i + 1).to_s
  end

  def self.search(parameter)
    if parameter[:match] == "Any Part of Field"
      keyword = "%" + parameter[:find_what] + "%"
      operator = "LIKE"
    elsif parameter[:match] == "Whole Field"
      keyword = parameter[:find_what]
      operator = "="
    else
      keyword = parameter[:find_what] + "%"
      operator = "LIKE"
    end

    conditions = ["1=1"]

    if parameter[:look_in] == "CR Job ID"
      conditions[0] += " AND client_requests.cr_job_id #{operator} ?"
      conditions << keyword
    else
      conditions[0] += ' AND ('
      self.new.attribute_names.each_with_index do |field, i|
        unless ["id", "project_id", "job_type_id", "contact_id", "job_status_id", "billing_to_contact_id", "billing_to_company_id", "company_id", "travel_id", "handling_id", "employee_production_id", "sale_id", "created_at", "updated_at"].include?(field)
          conditions[0] += " OR" if i > 0
          conditions[0] += " client_requests.#{field} #{operator} ?" and conditions << keyword
        end
      end
      conditions[0] += ')'
    end

    # find(:all, :conditions => conditions, :order => 'client_requests.cr_job_id DESC', :include => ["project"])
    where(conditions).includes(:project).order('client_requests.cr_job_id DESC')
  end
end
