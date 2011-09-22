class Account < ActiveRecord::Base

  has_many :tickets, :dependent => :destroy
	has_many :companies, :dependent => :destroy  
	# has_many :users, :dependent => :destroy
  
  before_create { default_values }
  	
	accepts_nested_attributes_for :companies # :reject_if => lambda { |a| a[:name].blank? }
	# accepts_nested_attributes_for :users
	
	def default_values
	  self.ticket_counter = 0 unless self.ticket_counter
	end
	
end
