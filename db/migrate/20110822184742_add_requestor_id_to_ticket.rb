class AddRequestorIdToTicket < ActiveRecord::Migration
  def self.up
    add_column :tickets, :requestor_id, :integer
  end

  def self.down
    remove_column :tickets, :requestor_id
  end
end
