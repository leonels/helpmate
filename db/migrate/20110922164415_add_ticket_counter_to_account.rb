class AddTicketCounterToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :ticket_counter, :integer
  end
end
