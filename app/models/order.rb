class Order < ActiveRecord::Base
	belongs_to :part
	belongs_to :ticket

	validates :price,
	:presence => true,
	:numericality => {:greater_than_or_equal_to => 0.01}

end
