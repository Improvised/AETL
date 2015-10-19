class Sale < ActiveRecord::Base
  attr_accessible :name
  
  has_one :company
  validates_presence_of :name
  validates_uniqueness_of :name

end

