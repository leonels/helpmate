class AddAccountIdToCompany < ActiveRecord::Migration
  def self.up
    add_column :companies, :account_id, :integer
  end

  def self.down
    remove_column :companies, :account_id
  end
end
