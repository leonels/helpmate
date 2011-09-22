class AddNumberToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :number, :integer
  end
end
