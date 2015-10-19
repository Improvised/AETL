# class Company < ActiveRecord::Base
#   attr_accessible :address_line_1, :address_line_2, :ar_notes, :billing_to_company_id, :city, :email, :fax, :name, :phone, :sale_id, :state, :website, :zip_code
# end


class Company < ActiveRecord::Base
  # attr_accessible :name ,:email ,:address_line_1 ,:address_line_2 ,:city ,:state ,:zip_code ,:phone ,:fax ,:billing_to_company_id, :sale_id, :website ,:ar_notes

  attr_accessible :address_line_1, :address_line_2, :ar_notes, :billing_to_company_id, :city, :email, :fax, :name, :phone, :sale_id, :state, :website, :zip_code
  after_save :check_billing_to_company
  has_many :contacts, :dependent => :delete_all
  belongs_to :sale
  belongs_to :company, :class_name => 'Company', :foreign_key => 'billing_to_company_id'
  has_many :client_requests
  has_many :billing_to_contacts, :class_name => 'Contact', :foreign_key => 'billing_to_contact_id'


  validates_presence_of :name, :sale_id
  validates_uniqueness_of :name

  private
  def check_billing_to_company
    # id = self.id.to_s
    # Company.find(id).update_attribute(:billing_to_company_id, id) if self.billing_to_company_id.blank?
    id = self.id
    Company.find(id).update_attributes(billing_to_company_id: id) if self.billing_to_company_id.blank?
  end
end

