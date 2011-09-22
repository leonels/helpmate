class Part < ActiveRecord::Base
	
	has_many :orders
	has_many :tickets, :through => :orders
	
	validates :name,
	:presence => true
	
	validates :cost,
	:presence => true,
	:numericality => {:greater_than_or_equal_to => 0.01}
	
	def cost_and_name
		'$' + cost.to_s + ' ' + name
  end
	
end
