class TicketsController < ApplicationController

	before_filter :load_collections, :only => [:new, :create, :edit, :update]
	before_filter :tickets_count, :only => [:index, :open, :solved, :assigned, :unassigned]
	
  def index
    # @tickets = Ticket.all(:order => 'created_at DESC')
    # @tickets = Ticket.accessible_by(current_ability, :order => 'created_at DESC')
    
    # if user is a customer, only show tickets that belongs to his company
    if current_user.role.name == "customer"
      @tickets = Ticket.all(:conditions => ["company_id = ?", current_user.company_id], :order => "created_at DESC")
    else
    # if user is an account owner or agent show tickets that belongs to account
      @tickets = Ticket.all(:conditions => ["account_id = ?", current_user.company.account_id], :order => "created_at DESC")
    end
    
    if @tickets.count == 0
      @blank = 'blank slate'
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tickets }
    end
  end

  def open
    if current_user.role.name == "customer"
      @tickets_open = Ticket.all(:conditions => ["company_id = ? AND ticket_status_id = ?", current_user.company_id, 1], :order => "created_at DESC")
    else
      @tickets_open = Ticket.all(:conditions => ["account_id = ? AND ticket_status_id = ?", current_user.company.account_id, 1], :order => "created_at DESC")
    end
  end
  
  def solved
    if current_user.role.name == "customer"
      @tickets_solved = Ticket.all(:order => "created_at DESC", :conditions => ["company_id = ? AND ticket_status_id = ?", current_user.company_id, 2])
    else
      @tickets_solved = Ticket.all(:order => "created_at DESC", :conditions => ["account_id = ? AND ticket_status_id = ?", current_user.company.account_id, 2])
    end
  end
  
  def assigned
    # customer shouldn't be allowed to see unassigned tickets
    if current_user.role.name == "customer"
      @tickets_assigned = ''
    else
      @tickets_assigned = Ticket.all(:order => "created_at DESC", :conditions => ["assignee_id = ? AND ticket_status_id = ?", current_user.id, 1])
    end
  end
  
  def unassigned
    # customer shouldn't be allowed to see unassigned tickets
    if current_user.role.name == "customer"
      @tickets_unassigned = ''
    else
      @tickets_unassigned = Ticket.find_all_by_assignee_id(nil, :order => "created_at DESC", :conditions => ["account_id = ? AND ticket_status_id = ?", current_user.company.account_id, 1])
    end
  end
  
  def show
    @ticket = Ticket.find(params[:id])
    authorize! :show, @ticket

    @orders = Order.all(:conditions => ["ticket_id = ?", @ticket.id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ticket }
    end
  end

  def new
    # @order = Order.new
    
    @ticket = Ticket.new
    @ticket.orders.build
    
    authorize! :create, @ticket

    # @order = @ticket.orders.build

    # 2.times { @ticket.parts.build }
    # 2.times { @ticket.orders.build }
  end

  # GET /tickets/1/edit
  def edit
    @ticket = Ticket.find(params[:id])
    @ticket.orders.build
    authorize! :update, @ticket
  end

  def create
    @ticket = Ticket.new(params[:ticket])   
    @ticket.account_id = current_user.company.account_id
        
    # set the requestor as the person submitting the ticket
    # unless the person submitting the ticket is the account owner
    if @ticket.requestor_id.nil? and current_user.role.name != 'account owner'
      @ticket.requestor_id = current_user.id
    end
    
    # set to Open if not status was set
    if @ticket.ticket_status_id.nil?
      @ticket.ticket_status_id = 1
    end

    # if solved
    if @ticket.ticket_status_id == 2
    	@ticket.solved_at = Time.now
    end

    @companies = Company.all(:conditions => ["account_id = ?", current_user.company.account_id], :order => "name DESC")
        
    if @ticket.company_id.nil?
      if @ticket.requestor.nil?
        @ticket.company_id = current_user.company_id
      else
        @ticket.company_id = @ticket.requestor.company_id
      end
    end
    # if user is a customer, attach company_id to ticket
    if current_user.role.name == "customer"
      @ticket.company_id == current_user.company_id
    end

    authorize! :create, @ticket

    respond_to do |format|
      if @ticket.save
      
      

        a = Account.find(@ticket.account_id)
	      @ticket.update_attribute(:number, a.ticket_counter)

      
      
      
        format.html { redirect_to(@ticket, :notice => 'Ticket was successfully created.') }
        format.xml  { render :xml => @ticket, :status => :created, :location => @ticket }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ticket.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @ticket = Ticket.find(params[:id])
    authorize! :update, @ticket
    
    if @ticket.company_id == nil
      if @ticket.requestor != nil
        @ticket.company_id = @ticket.requestor.company_id
      else
        @ticket.company_id = current_user.company_id
      end
    end
    
    # if open    
    if params[:ticket][:ticket_status_id] == "1"
    	@ticket.solver_id = nil
    # if solved
    elsif params[:ticket][:ticket_status_id] == "2"
    	@ticket.solver_id = current_user.id
    	@ticket.solved_at = Time.now
    end
    
    respond_to do |format|
      if @ticket.update_attributes(params[:ticket])      	
        format.html { redirect_to(@ticket, :notice => 'Ticket was successfully updated.') }
        # format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        # format.xml  { render :xml => @ticket.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @ticket = Ticket.find(params[:id])
    
    authorize! :destroy, @ticket
    
    @ticket.destroy

    respond_to do |format|
      format.html { redirect_to(tickets_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  def load_collections
  	@companies = Company.all(:conditions => ["account_id = ?", current_user.company.account_id], :order => "name DESC")
  	@ticket_statuses = TicketStatus.all
  	# @assignees = User.all(:conditions => ["company_id = ? AND role_id = ? OR role_id = ? OR role_id = ?", account_owner_company_id, 1,2,3 ])
  	@assignees = User.all(:conditions => ["company_id = ? AND (role_id = ? OR role_id = ? OR role_id = ?)", account_owner_company_id, 1,2,3 ])
  	@parts = Part.all
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
    
    # account_id = current_user.company.account_id
    # companies = Company.find_all_by_account_id(account_id)
    # account_owners = User.find_all_by_role_id(1)
    # account_owners.each do |ao|
    # end
    # @companies.each do |company|
    # @users = User.all(:order => 'first_name', :conditions => ["company_id = ?", company.id]) %>
    # @users.each do |user| %>
  end
  
  def tickets_count
    if current_user.role.name == 'customer'
  	  @tickets_count = Ticket.all(:conditions => ["company_id = ?", current_user.company_id], :order => "created_at DESC").count
  	  @tickets_open_count = Ticket.all(:conditions => ["company_id = ? and ticket_status_id = ?", current_user.company_id, 1], :order => "created_at DESC").count
      @tickets_solved_count = Ticket.all(:conditions => ["company_id = ? and ticket_status_id = ?", current_user.company_id, 2], :order => "created_at DESC").count
  	else
  	  @tickets_count = Ticket.all(:conditions => ["account_id = ?", current_user.company.account_id], :order => "created_at DESC").count
  	  @tickets_open_count = Ticket.all(:conditions => ["account_id = ? and ticket_status_id = ?", current_user.company.account_id, 1], :order => "created_at DESC").count
      @tickets_solved_count = Ticket.all(:conditions => ["account_id = ? and ticket_status_id = ?", current_user.company.account_id, 2], :order => "created_at DESC").count
  	  @tickets_assigned_count = Ticket.all(:conditions => ["assignee_id = ? AND ticket_status_id = ?", current_user.id, 1], :order => "created_at DESC").count
      @tickets_unassigned_count = Ticket.find_all_by_assignee_id(nil, :conditions => ["account_id = ? and ticket_status_id = ?", current_user.company.account_id, 1], :order => "created_at DESC").count
  	end
  end
  
end
