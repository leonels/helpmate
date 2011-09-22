class AddSolverIdToTicket < ActiveRecord::Migration
  def self.up
    add_column :tickets, :solver_id, :integer
  end

  def self.down
    remove_column :tickets, :solver_id
  end
end
