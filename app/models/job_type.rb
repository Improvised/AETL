class JobType < ActiveRecord::Base
  attr_accessible :name

  has_many :projects

  validates_presence_of :name
  validates_uniqueness_of :name

  def self.default
    # find(:first, :conditions => "name = 'Photo Simulation'", :select => "id").id
    where(name: "Photo Simulation").first.id
  end
end