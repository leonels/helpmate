class AddCompanyIdToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :company_id, :integer
  end
end
