class EmployeeProjectManager < ActiveRecord::Base
  attr_accessible :name

  # has_many :projects
  validates_presence_of :name
  validates_uniqueness_of :name
end
