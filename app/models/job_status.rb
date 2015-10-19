class JobStatus < ActiveRecord::Base
  attr_accessible :name

  has_many :projects
  has_many :client_requests
end
