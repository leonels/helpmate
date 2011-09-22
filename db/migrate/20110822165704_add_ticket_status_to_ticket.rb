class AddTicketStatusToTicket < ActiveRecord::Migration
  def self.up
    add_column :tickets, :ticket_status_id, :integer
  end

  def self.down
    remove_column :tickets, :ticket_status_id
  end
end
