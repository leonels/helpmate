class CompaniesController < ApplicationController
  
	load_and_authorize_resource

  def index
    # @companies = Company.all(:conditions => ["account_id == ?", current_user.company.account_id])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @companies }
    end
  end

  def show
  end

  def new
    # @company = Company.new
  	# @user = User.new
  	
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  def create
    # @company = Company.new(params[:company])
    # @company.account_id = current_user.company.account_id
    # @user = @company.users.build(params[:user])
    
      if @company.save
      	redirect_to(users_url, :notice => 'Company was successfully created.')
      else
      	render :action => "new"
      end
  end
  
  def edit
  end

  def update
    respond_to do |format|
      if @company.update_attributes(params[:company])
        format.html { redirect_to(@company, :notice => 'Company was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end
    end
  end

  def pre_delete
  	render :layout => "clean" 
  end
  
  def destroy
    @company.destroy

    respond_to do |format|
      format.html { redirect_to(users_url, :notice => 'The company has been deleted') }
      format.xml  { head :ok }
    end
  end
end
