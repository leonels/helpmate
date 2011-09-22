class AddInvitationLastSentToToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :invitation_last_sent_to, :timestamp
  end

  def self.down
    remove_column :users, :invitation_last_sent_to
  end
end
