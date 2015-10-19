class Project < ActiveRecord::Base

  attr_accessible :ae_job_id, :name, :number, :address_line_1, :address_line_2, :city, :state, :zip, :company_id,
    :contact_id, :account_manager_id, :date_in, :due_date, :job_status_id, :employee_production_id,
    :production_hour, :mileage, :employee_project_manager_id, :project_manager_hour, :job_type_id,
    :handling_id, :travel_id, :billing_to_company_id, :billing_to_contact_id, :billing_note, :price, 
    :invoice_number, :job_history, :delivery_id

  # before_save :check_invoice_number
  belongs_to :company
  belongs_to :contact
  belongs_to :handling
  belongs_to :travel
  belongs_to :billing_to_company, :class_name => "Company"
  belongs_to :billing_to_contact, :class_name => "Contact"
  belongs_to :job_type
  belongs_to :job_status
  belongs_to :delivery
  belongs_to :employee_production
  belongs_to :employee_project_manager
  has_many :contacts, :foreign_key => 'company_id', :primary_key => 'company_id'
  has_many :billing_to_contacts, :foreign_key => 'company_id', :primary_key => 'billing_to_company_id', :class_name => "Contact"
  belongs_to :account_manager, :class_name => "Sale"

  has_one :jobchecklist
  has_many :client_requests
  scope :prepare_project, lambda {|job_status, operator| {:joins => "INNER JOIN job_statuses ON job_status_id = job_statuses.id", :conditions => ["projects.job_status_id is NULL or job_statuses.name #{operator} ?", job_status], :order => "projects.ae_job_id DESC"}}
  scope :prepare_project_antdesc, lambda {|job_status, operator| {:joins => "INNER JOIN job_statuses ON job_status_id = job_statuses.id", :conditions => ["projects.job_status_id is NULL or job_statuses.name #{operator} ?", job_status], :order => "projects.ae_job_id"}}
  
  def create_ae_job_id
    number = "0"
    # project_rec = Project.find(:last, :conditions => "ae_job_id is not null")
    project_rec = Project.where("ae_job_id is not null").last
    unless project_rec.blank?
      last_ae_job_id = project_rec.ae_job_id
      year = last_ae_job_id.split("-")[0]
      number = last_ae_job_id.split("-")[1]
    end
    number = "0" if year.to_i != Time.now.year
    number = (number.to_i + 1) if number != "0"

    ae_job_id = Time.now.year.to_s + "-" + ("0" * (4 - number.to_i.to_s.size)) + (number.to_i).to_s
  end

  def self.search(parameter)
    keyword = parameter[:find_what]
    keyword = "%" + parameter[:find_what] + "%" if parameter[:match] == 'Any Part of Field'

    conditions = ["1=1"]
    parameter[:job_status] = "Active"
    


    unless parameter[:field] == "All Fields"
      conditions[0] += " AND companies.name LIKE ?" if parameter[:field] == "company"
      conditions[0] += " AND contacts.name LIKE ?" if parameter[:field] == "contact"
      conditions[0] += " AND projects.#{parameter[:field]} LIKE ?" unless ["company", "contact"].include?(parameter[:field])
      conditions << keyword
      # find(:all, :conditions => conditions, :include => [:company => [:contacts]], :order => "ae_job_id DESC")
      where(conditions).includes({company: :contacts}).order("ae_job_id DESC")
    else
      conditions[0] += " AND (projects.name LIKE ? OR projects.number LIKE ? OR projects.address_line_1 LIKE ? OR projects.city LIKE ? OR projects.state LIKE ? OR projects.zip LIKE ? OR projects.billing_note LIKE ? OR projects.invoice_number LIKE ?"
      conditions += [keyword, keyword, keyword, keyword, keyword, keyword, keyword, keyword]
  	
      #filter company_id and billing_to_company_id
      # company_records = Company.find(:all, :conditions => ["name LIKE ?", keyword], :select => "id")
      company_records = Company.where("name LIKE ?", keyword).select(:id)
      company_ids = company_records.blank? ? [] : company_records.collect{|p| p.id}
      unless company_ids.blank?
        conditions[0] += " OR projects.company_id IN (?) OR projects.billing_to_company_id IN (?)"
        conditions << company_ids
        conditions << company_ids
      end

      #filter contact_id and billing_to_contact_id
      # contact_records = Contact.find(:all, :conditions => ["name LIKE ?", keyword], :select => "id")
      contact_records = Contact.where("name LIKE ?", keyword).select(:id)

      contact_ids = contact_records.blank? ? [] : contact_records.collect{|p| p.id}
      unless contact_ids.blank?
        conditions[0] += " OR projects.contact_id IN (?) OR projects.billing_to_contact_id IN (?)"
        conditions << contact_ids
        conditions << contact_ids
      end

      #filter jobchecklist, carrier_id, and view
      ##carrier
      # carrier_records = Carrier.find(:all, :conditions => ["name LIKE ?", keyword], :select => "id")
      carrier_records = Carrier.where("name LIKE ?", keyword).select(:id)
      carrier_ids = carrier_records.blank? ? [] : carrier_records.collect{|p| p.id}
      
      ##view
      # view_records = ViewJobchecklist.find(:all, :conditions => ["view LIKE ? OR notes LIKE ? ", keyword, keyword], :select => "jobchecklist_id")
      view_records = ViewJobchecklist.where("view LIKE ? OR notes LIKE ? ", keyword, keyword).select(:jobchecklist_id)
      jobchecklist_ids = view_records.blank? ? [] : view_records.collect{|p| p.jobchecklist_id}
      
      ##jobchecklist
      conditions_jobchecklist = ["job_description LIKE ? OR notes LIKE ? "]
      conditions_jobchecklist += [keyword, keyword]
      unless jobchecklist_ids.blank?
        conditions_jobchecklist[0] += "OR id IN (?) "
        conditions_jobchecklist << jobchecklist_ids
      end
      unless carrier_ids.blank?
        conditions_jobchecklist[0] += "OR carrier_id IN (?) "
        conditions_jobchecklist << carrier_ids
      end
      # jobchecklist_records = Jobchecklist.find(:all, :conditions => conditions_jobchecklist, :select => "project_id")
      jobchecklist_records = Jobchecklist.where(conditions_jobchecklist).select(:project_id)
      project_ids = jobchecklist_records.blank? ? [] : jobchecklist_records.collect{|p| p.project_id}
      unless project_ids.blank?
        conditions[0] += " OR projects.id IN (?)"
        conditions << project_ids
      end
      conditions[0] += ")"

      # find(:all, :conditions => conditions, :order => "ae_job_id DESC")
      where(conditions).order("ae_job_id DESC")
    end
  end

 def self.search_ewa(parameter)
    keyword = parameter[:find_what]
    keyword = "%" + parameter[:find_what] + "%" if parameter[:match] == 'Broad Match'

    conditions = ["1=1"]
    parameter[:job_status] = "All Jobs" if parameter[:job_status].blank?
    unless parameter[:job_status] == "Active"
      conditions[0] += " AND projects.job_status_id " + (parameter[:job_status] == "Active" ? "!" : "") + "= 3"
    end

    unless parameter[:field] == "All Fields"
      conditions[0] += " AND companies.name LIKE ?" if parameter[:field] == "company"
      conditions[0] += " AND contacts.name LIKE ?" if parameter[:field] == "contact"
      conditions[0] += " AND projects.#{parameter[:field]} LIKE ?" unless ["company", "contact"].include?(parameter[:field])
      conditions << keyword
      # find(:all, :conditions => conditions, :include => [:company => [:contacts]], :order => "ae_job_id DESC")
      where(conditions).includes(company: :contacts).order("ae_job_id DESC")
    else
      conditions[0] += " AND (projects.name LIKE ? OR projects.number LIKE ? OR projects.address_line_1 LIKE ? OR projects.city LIKE ? OR projects.state LIKE ? OR projects.zip LIKE ? OR projects.billing_note LIKE ? OR projects.invoice_number LIKE ?"
      conditions += [keyword, keyword, keyword, keyword, keyword, keyword, keyword, keyword]
    
      #filter company_id and billing_to_company_id
      # company_records = Company.find(:all, :conditions => ["name LIKE ?", keyword], :select => "id")
      company_records = Company.where("name LIKE ?", keyword).select(:id)
      company_ids = company_records.blank? ? [] : company_records.collect{|p| p.id}
      unless company_ids.blank?
        conditions[0] += " OR projects.company_id IN (?) OR projects.billing_to_company_id IN (?)"
        conditions << company_ids
        conditions << company_ids
      end

      #filter contact_id and billing_to_contact_id
      # contact_records = Contact.find(:all, :conditions => ["name LIKE ?", keyword], :select => "id")
      contact_records = Contact.where("name LIKE ?", keyword).select(:id)

      contact_ids = contact_records.blank? ? [] : contact_records.collect{|p| p.id}
      unless contact_ids.blank?
        conditions[0] += " OR projects.contact_id IN (?) OR projects.billing_to_contact_id IN (?)"
        conditions << contact_ids
        conditions << contact_ids
      end

      #filter jobchecklist, carrier_id, and view
      ##carrier
      # carrier_records = Carrier.find(:all, :conditions => ["name LIKE ?", keyword], :select => "id")
      carrier_records = Carrier.where("name LIKE ?", keyword).select(:id)
      carrier_ids = carrier_records.blank? ? [] : carrier_records.collect{|p| p.id}
      
      ##view
      # view_records = ViewJobchecklist.find(:all, :conditions => ["view LIKE ? OR notes LIKE ? ", keyword, keyword], :select => "jobchecklist_id")
      view_records = ViewJobchecklist.where("view LIKE ? OR notes LIKE ? ", keyword, keyword).select(:jobchecklist_id)
      jobchecklist_ids = view_records.blank? ? [] : view_records.collect{|p| p.jobchecklist_id}
      
      ##jobchecklist
      conditions_jobchecklist = ["job_description LIKE ? OR notes LIKE ? "]
      conditions_jobchecklist += [keyword, keyword]
      unless jobchecklist_ids.blank?
        conditions_jobchecklist[0] += "OR id IN (?) "
        conditions_jobchecklist << jobchecklist_ids
      end
      unless carrier_ids.blank?
        conditions_jobchecklist[0] += "OR carrier_id IN (?) "
        conditions_jobchecklist << carrier_ids
      end
      # jobchecklist_records = Jobchecklist.find(:all, :conditions => conditions_jobchecklist, :select => "project_id")
      jobchecklist_records = Jobchecklist.where(conditions_jobchecklist).select(:project_id)
      project_ids = jobchecklist_records.blank? ? [] : jobchecklist_records.collect{|p| p.project_id}
      unless project_ids.blank?
        conditions[0] += " OR projects.id IN (?)"
        conditions << project_ids
      end
      conditions[0] += ")"

      # find(:all, :conditions => conditions, :order => "ae_job_id DESC")
      where(conditions).order("ae_job_id DESC")
    end
  end

  def self.job_scorecard(parameter)
    conditions = ["1=1"]
    conditions[0] += " AND company_id = ?" unless parameter[:company_id].blank?
    conditions[0] += " AND contact_id = ?" unless parameter[:contact_id].blank?
    conditions[0] += " AND date_in >= ?" unless parameter[:date_in].blank?
    conditions[0] += " AND due_date <= ?" unless parameter[:due_date].blank?
    conditions << parameter[:company_id] unless parameter[:company_id].blank?
    conditions << parameter[:contact_id] unless parameter[:contact_id].blank?
    conditions << parameter[:date_in] unless parameter[:date_in].blank?
    conditions << parameter[:due_date] unless parameter[:due_date].blank?

    # find(:all, :conditions => conditions, :include => [:contacts])
    Project.where(conditions).includes(:contacts)
  end

  # def self.create_revision(id, revision)
  #   project_rec = find(id)
  #   unless project_rec.jobchecklist.blank?
  #     jobchecklist_rec = project_rec.jobchecklist
  #     unless jobchecklist_rec.views.empty?
  #       views_rec = jobchecklist_rec.views
  #     end
  #   end

  #   nrevision_rec = Project.new
  #   njobchecklist_rec = Jobchecklist.new
  #   nviews_rec = []
  #   nrevision_rec.job_type_id = 3
  #   nrevision_rec.handling_id = 3
  #   nrevision_rec.travel_id = 2
    
  #   if revision[:keep_infomation] == '1'
  #     nrevision_rec.ae_job_id = nrevision_rec.create_ae_job_id
  #     nrevision_rec.job_history = revision[:ae_job_id] +(revision[:job_history].blank? ? "" : ", " + revision[:job_history] )
  #     nrevision_rec.name = project_rec.name
  #     nrevision_rec.number = project_rec.number
  #     nrevision_rec.company_id = project_rec.company_id
  #     nrevision_rec.contact_id = project_rec.contact_id
  #     nrevision_rec.job_status_id = JobStatus.find_by_name('In Pre-Production')
  #     nrevision_rec.build_jobchecklist({:carrier_id => jobchecklist_rec.carrier_id, :layout_id => jobchecklist_rec.layout_id }) unless jobchecklist_rec.blank?      
  #   end

  #   if revision[:keep_site_address] == "1"
  #     nrevision_rec.address_line_1 = project_rec.address_line_1
  #     nrevision_rec.address_line_2 = project_rec.address_line_2
  #     nrevision_rec.city = project_rec.city
  #     nrevision_rec.state = project_rec.state
  #     nrevision_rec.zip = project_rec.zip
  #   end

  #   nrevision_rec.date_in = Time.now
  #   nrevision_rec.save!
  #   unless nrevision_rec.jobchecklist.blank?
  #     njobchecklist_rec = nrevision_rec.jobchecklist
  #     njobchecklist_rec.notes = "Revision of " + revision[:ae_job_id]      
  #     njobchecklist_rec.save!
  #   end

  #   if revision[:keep_view_description] == '1'
  #     unless views_rec.blank?
  #       views_rec.each do |x|
  #         nviews_rec << ViewJobchecklist.new({:view => x.view})
  #       end
  #       njobchecklist_rec.views = nviews_rec
  #     end
  #   end
  # end

  def self.create_revision(id, revision)
    project_obj = Project.find(id)
    project = project_obj.attributes
    unless project_obj.jobchecklist.blank?
      jobchecklist_rec = project_obj.jobchecklist
      unless jobchecklist_rec.views.empty?
        views_rec = jobchecklist_rec.views
      end
    end

    project.delete("id")
    project.delete("created_at")
    project.delete("updated_at")

    project["date_in"] = Time.now
    project["job_type_id"] = 3
    project["handling_id"] = 3
    project["travel_id"] = 2

    rev = Project.new(project)
    njobchecklist_rec = Jobchecklist.new
    rev["job_status_id"] = JobStatus.where(name: 'In Pre-Production').first.id

    if revision[:keep_infomation] == '1'
      rev["ae_job_id"] = Project.new.create_ae_job_id
      rev["job_history"] = revision[:ae_job_id] +(revision[:job_history].blank? ? "" : ", " + revision[:job_history] )
      rev.build_jobchecklist({:carrier_id => jobchecklist_rec.carrier_id, :layout_id => jobchecklist_rec.layout_id }) unless jobchecklist_rec.blank?
    else
      rev["ae_job_id"] = ""
      rev["job_history"] = ""
      rev["name"] = ""
      rev["number"] = ""
      rev["company_id"] = ""
      rev["contact_id"] = ""
      # rev["job_status_id"] = ""
    end

    if revision[:keep_site_address] != "1"
      rev["address_line_1"] = ""
      rev["address_line_2"] = ""
      rev["city"] = ""
      rev["state"] = ""
      rev["zip"] = ""
    end

    rev.save!
    unless rev.jobchecklist.blank?
      njobchecklist_rec = rev.jobchecklist
      njobchecklist_rec.notes = "Revision of " + revision[:ae_job_id]      
      njobchecklist_rec.save!
    end

    if revision[:keep_view_description] == '1'
      unless views_rec.blank?
        views_rec.each do |x|
          content = x.attributes
          content.delete("id")
          content.delete("created_at")
          content.delete("updated_at")
          njobchecklist_rec.views.create(content)
        end
      end
    end
  end

  def after_save
    rec_jobchecklist = self.jobchecklist
    unless rec_jobchecklist.blank?
       # rec_jobchecklist.update_attribute(:employee_project_manager_id, self.employee_project_manager_id) if rec_jobchecklist.employee_project_manager_id != self.employee_project_manager_id
       rec_jobchecklist.update_attributes(employee_project_manager_id: self.employee_project_manager_id) if rec_jobchecklist.employee_project_manager_id != self.employee_project_manager_id
    end
  end
  
  private
  def check_invoice_number
    self.job_status_id = "3" if !invoice_number.blank?
  end
end
