class Role < ActiveRecord::Base

  # 1 account owner
  # 2 manager
  # 3 agent
  # 4 customer
  # 5 admin

	has_many :users  
	
	validates :name,
	:presence => true,
	:uniqueness => true

end
