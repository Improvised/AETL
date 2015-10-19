class Handling < ActiveRecord::Base
  attr_accessible :name

  has_many :client_requests

  validates_presence_of :name
  validates_uniqueness_of :name

  def self.default
    # find(:first, :conditions => "name = 'Standard'", :select => "id").id
    where(name: "Standard").first.id
  end
end