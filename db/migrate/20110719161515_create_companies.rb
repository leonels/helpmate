class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.string :name
      t.string :address_one
      t.string :address_two
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :web_address
      t.string :phone_number_office
      t.string :phone_number_fax

      t.timestamps
    end
  end

  def self.down
    drop_table :companies
  end
end
