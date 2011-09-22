class AddUserStateToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :user_state, :string
  end

  def self.down
    remove_column :users, :user_state
  end
end
