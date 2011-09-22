class TicketStatus < ActiveRecord::Base
	# 1 Open
	# 2 Solved
	has_many :tickets
end
