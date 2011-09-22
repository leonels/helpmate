class Ticket < ActiveRecord::Base

  belongs_to :account
	belongs_to :ticket_status
	belongs_to :requestor, :class_name => "User"
	belongs_to :solver, :class_name => "User"
	belongs_to :assignee, :class_name => "User"
	
	# has_and_belongs_to_many :parts
	# accepts_nested_attributes_for :parts, :reject_if => lambda { |a| a[:name].blank? }
	has_many :orders, :dependent => :destroy
	has_many :parts, :through => :orders
	accepts_nested_attributes_for :orders, :reject_if => lambda { |a| a[:part_id].blank? }, :allow_destroy => true
	accepts_nested_attributes_for :parts
	
	after_create :increment_ticket
	
	validates :account_id,
	:presence => true
	
	validates :subject,
	:presence => true
	
	validates :description,
	:presence => true
	
	validates :ticket_status,
	:presence => true
	
	validates :requestor_id,
	:presence => true
	
	def increment_ticket
	  Account.increment_counter(:ticket_counter, self.account_id)
	end
	
	def abbreviated_created_at
		created_at.strftime("%a %b %d at %I:%M%P")
	end
	
  def abbreviated_solved_at
		solved_at.strftime("%a %b %d at %I:%M%P")
	end
	
	def date_created_at
		created_at.strftime("%a %b %d")
	end
	
	def date_solved_at
		solved_at.strftime("%a %b %d")
	end
	
	def full_created_at
		created_at.strftime("%B %d, %Y at %I:%M%P")
	end
	
	# add validation
	# if status == closed, then there should be a valid solver_id

end
