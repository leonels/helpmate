class UsersController < ApplicationController
		
	load_and_authorize_resource :class => User
	
	def index
		# account owner or manager or agent
		if current_user.role_id == 1 or current_user.role_id == 2 or current_user.role_id == 3
			@companies = Company.all(:conditions => ["account_id == ?", current_user.company.account_id])
		else
			@companies = Company.all(:conditions => ["id == ? or id == ?", current_user.company_id, account_owner_company_id])
		end
  end
	
  def new
    @company = Company.find(params[:company_id])
  	@user = @company.users.build
  	
    respond_to do |format|
      format.html
      format.xml  { render :xml => @user }
    end
  end
    
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @user }
    end
  end
  
  def create
  	@company = Company.find(params[:company_id])
  	@user = @company.users.build(params[:user])
    @user.user_state = "invited"
  	@user.confirmation_token = 'a' + current_user.company.account_id.to_s + 't' + Time.now.strftime("%Y%m%d%H%M%S") + 'R' + rand(36**8).to_s(36)
    @user.invitation_last_sent_at = Time.now
    @user.invitation_last_sent_to = @user.email

  	if is_company_the_account_holder_company?(@company, current_user)
  		# agent
  		@user.role_id = 3
  	else
  		# customer
  		@user.role_id = 4
  	end

    respond_to do |format|
      if @user.save
					user_long_name = @user.first_name + ' ' + @user.last_name + ' has been emailed a link to sign into their account.'
					Notifier.user_invited(@user).deliver
					format.html { redirect_to(users_url, :notice => user_long_name) }
					format.xml  { render :xml => @user, :status => :created, :location => @company }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(:action => 'edit') }
      else
        flash[:error] = 'User was not updated.'
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
    	flash[:notice] = @user.first_name + ' ' + @user.last_name + ' has been deleted.'
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
  
  # there are two kinds of companies
  # 1) account holder company (account owners, managers, agents)
  # 2) customer company
  def is_company_the_account_holder_company?(company, current_user)
    company.id == current_user.company_id
  end
  
  def account_owner_company_id
  	customer_account_id = current_user.company.account_id
  	account_owners = User.find_all_by_role_id(1)
    account_owners.each do |ao|
      if ao.company.account_id == customer_account_id
  	    @this_one = ao.company_id
      end
    end
    @this_one
  end

end
