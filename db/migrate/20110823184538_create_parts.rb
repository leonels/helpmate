class CreateParts < ActiveRecord::Migration
  def self.up
    create_table :parts do |t|
      t.string :name
      t.decimal :cost
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :parts
  end
end
