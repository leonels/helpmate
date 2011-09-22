class Ability
	include CanCan::Ability
	
	def initialize(current_user)
		if current_user.role.name == "admin"

		  can :manage, :all

		elsif current_user.role.name == "account owner"

      # from same account
      can :manage, Account, :id => current_user.company.account_id
      can :manage, Company, :account_id => current_user.company.account_id
      
      cannot :destroy, Company do |company|
        is_this_the_account_owner_company?(company, current_user)
      end
      
      can :manage, User do |user|
      	is_the_user_from_the_same_account?(user, current_user)
      end
      can :create, User # has to be right after the User block above
      # because is_the_user_from_the_same_account looks for an
      # account_id and since it's a new user, it doesn't have it
      # yet and it prompts the following error
      # undefined method `account_id' for nil:NilClass
      
      # todo: prevent user from deleting himself, something like
      # if user role is account owner, he can't be deleted
      cannot :destroy, User do |user|
      	user.role.name == "account owner"
      end
      
      #####################################
      #
      #            Ticket
      #
      #####################################
      # can :read, Ticket, :account_id => current_user.company.account_id
      # can :read, Ticket do |ticket|
      #   is_ticket_from_same_account?(ticket, current_user)
      # end
      can :manage, Ticket, :account_id => current_user.company.account_id
      cannot :destroy, Ticket do |ticket|
        ticket.account_id != current_user.company.account_id
      end
      can :create, Ticket
            
		elsif current_user.role.name == "agent"
			
			cannot [:pre_cancel], Account
			
      # from same account
      can [:index, :show], Company, :account_id => current_user.company.account_id
      
      can [:index], User
      
      # can only show and update himself
      can [:show, :update], User, :auth_token => current_user.auth_token
      can [:show], User do |user|
      	is_the_user_from_the_same_account?(user, current_user)
      end

      #####################################
      #
      #            Ticket
      #
      #####################################
      can :create, Ticket
      can :index, Ticket
      can :show, Ticket, :account_id => current_user.company.account_id
      # can :update, Ticket, :requestor_id => current_user.id
      can :update, Ticket, :account_id => current_user.company.account_id
      cannot :destroy, Ticket
      
    elsif current_user.role.name == "customer"

    	cannot [:pre_cancel], Account
    	
      can :show, Company, :id => current_user.company_id
      can :show, Company do |company|
      	is_this_the_account_owner_company?(company, current_user)
      end
      
      can :index, User, :company_id => current_user.company_id
      can :show, User, :company_id => current_user.company_id
      can :update, User, :auth_token => current_user.auth_token
      
      can :show, User do |user|
      	is_the_user_from_account_owner_company?(user, current_user)
      end
      
      #####################################
      #
      #            Ticket
      #
      #####################################

      # can :show, Ticket, :account_id => current_user.company.account_id

      can :create, Ticket
      can :index, Ticket
      can :show, Ticket do |ticket|
        ticket.requestor.company_id == current_user.company_id
      end
      cannot :update, Ticket
      cannot :destroy, Ticket
            
    elsif current_user.role.name == "guest"
    	# fix sign up
    	# you should really remove the following line
    	can :new, Account
    	can :create, Account
    	cannot [:pre_cancel], Account
		end

	end
	
	# about this method
	# warning. please refer to https://github.com/ryanb/cancan/wiki/Defining-Abilities-with-Blocks
	# under Only for Object Attributes
	def is_the_user_from_the_same_account?(user, current_user)
		user.company.account_id == current_user.company.account_id
	end
	
	# def is_account_owner(id)
	#	User.find_all_by_id_and_role_id_and_user_state(id, 1, "signed_up")
	# end

	# def is_account_owner?(user, current_user)
	# 	all_companies_in_account = current_user.company.account.companies
  #   account_owner = User.find_by_role_id_and_company_id(1, all_companies_in_account)
  #   account_owner.id == user.id
  # end
	
	def is_this_the_account_owner_company?(company, current_user)
  	customer_account_id = current_user.company.account_id
  	account_owners = User.find_all_by_role_id(1)
    account_owners.each do |ao|
      if ao.company.account_id == customer_account_id
  	    @this_one = ao.company_id
      end
    end
    if @this_one == company.id
    	true
    else
    	false
    end
	end

	def is_the_user_from_account_owner_company?(user, current_user)
  	customer_account_id = current_user.company.account_id
  	account_owners = User.find_all_by_role_id(1)
    account_owners.each do |ao|
      if ao.company.account_id == customer_account_id
  	    @this_one = ao.company_id
      end
    end   
    if @this_one == user.company_id
    	true
    else
    	false
    end
  end
  
end
