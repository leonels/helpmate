class AddSolvedAtToTicket < ActiveRecord::Migration
  def self.up
    add_column :tickets, :solved_at, :timestamp
  end

  def self.down
    remove_column :tickets, :solved_at
  end
end
