class Contact < ActiveRecord::Base

	attr_accessible :company_id, :email, :fax, :name, :phone

  belongs_to :company
  # has_many :projects
  # has_many :client_requests

  validates_presence_of :name
  
end
