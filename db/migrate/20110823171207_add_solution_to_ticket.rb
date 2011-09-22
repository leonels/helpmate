class AddSolutionToTicket < ActiveRecord::Migration
  def self.up
    add_column :tickets, :solution, :text
  end

  def self.down
    remove_column :tickets, :solution
  end
end
