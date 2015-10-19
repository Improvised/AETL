class Travel < ActiveRecord::Base
  attr_accessible :name

  has_many :client_requests

  validates_presence_of :name
  validates_uniqueness_of :name

  def self.default
    # find(:first, :conditions => "name = 'AE Photographed'", :select => "id").id
    where(name: "AE Photographed").first.id
  end
end
