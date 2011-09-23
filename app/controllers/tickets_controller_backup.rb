class TicketsController < ApplicationController

	before_filter :load_collections, :only => [:new, :create, :edit, :update]
	before_filter :tickets_count, :only => [:index, :open, :solved, :assigned, :unassigned]
	
  def index
    @tickets = Ticket.all(:conditions => ["account_id = ?", current_user.company.account_id], :order => "created_at DESC")
    # @tickets = Ticket.all(:order => 'created_at DESC')
    # @tickets = Ticket.accessible_by(current_ability, :order => 'created_at DESC')
    
    if @tickets.count == 0
      @blank = 'blank slate'
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tickets }
    end
  end

  def open
    @tickets_open = Ticket.all(:order => "created_at DESC", :conditions => ["ticket_status_id = ?", 1])
  end
  
  def solved
    @tickets_solved = Ticket.all(:order => "created_at DESC", :conditions => ["ticket_status_id = ?", 2])
  end
  
  def assigned
  	@tickets_assigned = Ticket.all(:order => "created_at DESC", :conditions => ["assignee_id = ? AND ticket_status_id = ?", current_user.id, 1])
  end
  
  def unassigned
  	@tickets_unassigned = Ticket.find_all_by_assignee_id(nil, :order => "created_at DESC", :conditions => ["ticket_status_id = ?", 1])
  end
  
  def show
    @ticket = Ticket.find(params[:id])

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
    # @order = @ticket.orders.build

    # 2.times { @ticket.parts.build }
    # 2.times { @ticket.orders.build }
  end

  # GET /tickets/1/edit
  def edit
    @ticket = Ticket.find(params[:id])
    @ticket.orders.build
  end

  # POST /tickets
  # POST /tickets.xml
  def create
    
    @ticket = Ticket.new(params[:ticket])
    @ticket.ticket_status_id = 1
    @ticket.requestor_id = current_user.id
    @ticket.account_id = current_user.company.account_id

    respond_to do |format|
      if @ticket.save
        format.html { redirect_to(@ticket, :notice => 'Ticket was successfully created.') }
        format.xml  { render :xml => @ticket, :status => :created, :location => @ticket }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ticket.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tickets/1
  # PUT /tickets/1.xml
  def update
    @ticket = Ticket.find(params[:id])

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

  # DELETE /tickets/1
  # DELETE /tickets/1.xml
  def destroy
    @ticket = Ticket.find(params[:id])
    @ticket.destroy

    respond_to do |format|
      format.html { redirect_to(tickets_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  def load_collections
  	@ticket_statuses = TicketStatus.all
  	@assignees = User.all(:conditions => ["role_id = ? or role_id = ? or role_id = ?", 1,2,3 ])
  	@parts = Part.all
  end
  
  def tickets_count
  	@tickets_count = Ticket.all(:order => "created_at DESC").count
  	@tickets_open_count = Ticket.all(:order => "created_at DESC", :conditions => ["ticket_status_id = ?", 1]).count
    @tickets_solved_count = Ticket.all(:order => "created_at DESC", :conditions => ["ticket_status_id = ?", 2]).count
  	@tickets_assigned_count = Ticket.all(:order => "created_at DESC", :conditions => ["assignee_id = ? AND ticket_status_id = ?", current_user.id, 1]).count
  	@tickets_unassigned_count = Ticket.find_all_by_assignee_id(nil, :order => "created_at DESC", :conditions => ["ticket_status_id = ?", 1]).count
  end
  
end
