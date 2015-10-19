class Jobchecklist < ActiveRecord::Base
  attr_accessible :project_id, :carrier_id, :employee_project_manager_id, :job_description, :number_of_copies, :layout_id, :notes

  belongs_to :project
  belongs_to :carrier
  belongs_to :layout
  has_many :views, :class_name => "ViewJobchecklist", :dependent => :delete_all


  def after_save
    # rec_project = self.project
    # unless rec_project.blank?
    #    rec_project.update_attribute(:employee_project_manager_id, self.employee_project_manager_id) if rec_project.employee_project_manager_id != self.employee_project_manager_id
    # end

    rec_project = self.project
    unless rec_project.blank?
       rec_project.update_attributes(employee_project_manager_id: self.employee_project_manager_id) if rec_project.employee_project_manager_id != self.employee_project_manager_id
    end
  end
end

