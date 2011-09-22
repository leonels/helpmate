class AddAccountIdToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :account_id, :integer
  end
end
