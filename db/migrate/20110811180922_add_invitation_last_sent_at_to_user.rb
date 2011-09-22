class AddInvitationLastSentAtToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :invitation_last_sent_at, :timestamp
  end

  def self.down
    remove_column :users, :invitation_last_sent_at
  end
end
