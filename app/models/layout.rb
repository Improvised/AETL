class Layout < ActiveRecord::Base
  attr_accessible :name, :tabloid, :landscape

  validates_presence_of :name
  validates_uniqueness_of :name

  def self.default
    # find(:first, :conditions => "name = 'standard layout (17 x 11 landscape)'", :select => 'id').id
    where(name: "standard layout (17 x 11 landscape)").first.id
  end

end
