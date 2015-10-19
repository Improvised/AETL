class ViewJobchecklist < ActiveRecord::Base
  attr_accessible :jobchecklist_id, :view, :notes, :time_of_day_shot, :field_of_view

  belongs_to :jobchecklist
end

