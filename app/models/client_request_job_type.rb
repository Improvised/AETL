class ClientRequestJobType < ActiveRecord::Base
	attr_accessible :id, :name

  has_many :client_requests

  validates_presence_of :name
  validates_uniqueness_of :name

end