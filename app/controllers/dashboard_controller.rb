class DashboardController < ApplicationController

	def index
	  if current_user.role.name == "customer"
		  @tickets_requested_by_me = Ticket.all(:conditions => ["requestor_id == ?", current_user.id], :order => "created_at DESC")
		  @tickets_for_company = Ticket.all(:conditions => ["company_id == ?", current_user.company_id], :order => "created_at DESC")
		else
		  @tickets_assigned_count = Ticket.all(:order => "created_at DESC", :conditions => ["assignee_id == ? AND ticket_status_id == ?", current_user.id, 1]).count
  	  @tickets_assigned = Ticket.all(:order => "created_at DESC", :conditions => ["assignee_id == ? AND ticket_status_id == ?", current_user.id, 1])
    end
  end
	
end
