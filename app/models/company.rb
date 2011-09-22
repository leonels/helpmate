class Company < ActiveRecord::Base

	belongs_to :account
	# validates_presence_of :account_id, :except => :create
	
	# in the delete confirmation, specify "all users under this company will be deleted. ok?"
	has_many :users, :dependent => :destroy
	accepts_nested_attributes_for :users
	
	validates :name, :presence => true
	
end
