class AccountsController < ApplicationController
  
	skip_before_filter :authorize, :only => [:new, :create, :goodbye]
	before_filter :stay_inside_app, :only => [:new, :create]
	
	load_and_authorize_resource
	
	def index
    respond_to do |format|
      format.html
      format.xml  { render :xml => @accounts }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml  { render :xml => @account }
    end
  end

  def new
    company = @account.companies.build
    company.users.build
    
    respond_to do |format|
      format.html { render :layout => "clean" }
      # format.html { render :layout => "signup" }
    end
  end
  
  def create
  	@account = Account.new(params[:account])
    @account.companies[0].users[0].user_state = "signed_up"
    @account.companies[0].users[0].role_id = 1
  	# build is already on new, so you don't need it again
  	# @account.companies.build(params[:companies])
    # params[:companies].each_value do |company|
    #	@account.tasks.build(company) unless company.values.all?(&:blank?)
    # end
    
      if @account.save
      	Notifier.user_signedup(@account).deliver
      	redirect_to(log_in_path, :notice => 'User was successfully created. Please sign in.')
        # format.html { redirect_to(@company, :notice => 'User was successfully created.') }
        # format.xml  { render :xml => @company, :status => :created, :location => @company }
      else
        render :action => "new", :layout => "clean"
      	# render :action => "new", :layout => "signup"
        # format.html { render :action => "new" }
        # format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end
    # end
  end
  
  def edit
  end

  def update
    respond_to do |format|
      if @account.update_attributes(params[:account])
        format.html { redirect_to(@account, :notice => 'Account was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  def pre_cancel
  	render :layout => "clean" 
  end
  
  def goodbye
  	render :layout => "clean"
  end
  
  def destroy
    cookies.delete(:auth_token)
    @account.destroy
    redirect_to goodbye_path
  end
end
