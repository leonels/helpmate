class AddAssigneeIdToTicket < ActiveRecord::Migration
  def self.up
    add_column :tickets, :assignee_id, :integer
  end

  def self.down
    remove_column :tickets, :assignee_id
  end
end
