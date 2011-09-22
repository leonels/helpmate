class User < ActiveRecord::Base

  # belongs_to :account
	belongs_to :company
  
	belongs_to :role
	
	has_many :requestors, :through => :tickets
	
	attr_accessible	:email,
									:password,
									:password_confirmation,
									:first_name,
									:last_name,
									:username,
									:title,
									:company_id,
									# :account_id,
									:user_state,
									:confirmed_at,
									:role_id,
									:invitation_last_sent_at,
									:invitation_last_sent_to
	
	attr_accessor :password
	before_save :encrypt_password
  
	# attr_accessor :current_password
		
	before_create { generate_token(:auth_token) }

	def full_name
		first_name + ' ' + last_name
	end
	
	def abbreviated_name
		first_name + ' ' + last_name[0,1]
	end
	
	def full_name_and_company
	  first_name + ' ' + last_name + ', ' + company.name
	end
		
  # username can't be changed, so there is no need for :on => :update
	validates :username,
	:presence => true,
	:uniqueness => true,
  :length => { :minimum => 3, :maximum => 30, :message => 'should have between 3 to 30 characters' },
  :on => :create,
  :unless => Proc.new {|user| user.user_state == "invited"}
	
	validates :password,
	:presence => true,
	:length => { :minimum => 6, :maximum => 20, :message => 'should have between 6 to 12 characters' },
	:confirmation => true,
	:unless => Proc.new {|user| user.password.nil?}
  	
	##############################################
	# ------------
  # user_state
  # ------------
  # signed_up
  # invited
  # confirmed
  # 
  # --------
  # roles
  # --------
  # account owner
  # manager
  # agent
  # customer
  # guest
  #
  # accounts
  # create
  #
  # users
  # create
  # update
  #
  # invitations
  # resend (invitation_last_sent_at, invitation_last_sent_to)
  # activate (username, password, user_state, confirmed_at)
  #
  # password_change
  # update
  #
  # password_resets
  # update  
	#############################################

  # validates :password,
	# :confirmation => true
	
	validates :role_id,
	:presence => true
	  		
	validates :user_state,
  :presence => true

  validates :email,
  :presence => true,
  :uniqueness => true,
  :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }
	
	validates :first_name,
	:presence => true
	
	validates :last_name,
	:presence => true

  def account_owner
  	customer_account_id = self.company.account_id
  	account_owners = User.find_all_by_role_id(1)
    account_owners.each do |ao|
      if ao.company.account_id == customer_account_id
  	    @this_company = ao.company_id
  	    @this_account_owner = ao.full_name
      end
    end   
    @this_account_owner
  end  

  def account_owner_email
  	customer_account_id = self.company.account_id
  	account_owners = User.find_all_by_role_id(1)
    account_owners.each do |ao|
      if ao.company.account_id == customer_account_id
  	    @this_email = ao.email
      end
    end   
    @this_email
  end

	
	def are_you_inviting_a_user?
		self.user_state == "about_to_invite"
	end
	
  def are_you_activating_your_account?
  	self.user_state == "invited"
  end
	
  def send_password_reset
  	generate_token(:password_reset_token)
  	self.password_reset_sent_at = Time.zone.now
  	save!(:validate => false)
  	Notifier.password_reset(self).deliver
  end
  
  def generate_token(column)
  	begin
  		# when update to ruby 1.9 use the line below instead
  		# self[column] = SecureRandom.urlsafe_base64
  		self[column] = SecureRandom.hex
  	end while User.exists?(column => self[column])
  end
  
	def self.authenticate(username, password)
		user = find_by_username(username)
		if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
			user
		else
			nil
		end
	end
	
	def encrypt_password
		if password.present?
			self.password_salt = BCrypt::Engine.generate_salt
			self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
		end
	end
	
end
