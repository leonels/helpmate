class CorrectInvitationLastSentToColumnType < ActiveRecord::Migration
  def self.up
  	change_column :users, :invitation_last_sent_to, :string
  end

  def self.down
  	raise ActiveRecord::IrreversibleMigration
  end
end
