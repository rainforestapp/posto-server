class AddAppIdToOutgoingEmailTasks < ActiveRecord::Migration
  def change
    add_column :outgoing_email_tasks, :app_id, :integer, null: false, limit: 8
  end
end
