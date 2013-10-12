require "migrations/migration_helpers"

class AddSmsLogEntries < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_posto_table :sms_log_entries do |t|
      t.integer :app_id, null: false, limit: 8
      t.string :sms_type, null: false, limit: 32
      t.string :destination, null: false, limit: 32
      t.string :message, null: false, limit: 256
      t.timestamps
    end

    add_index :sms_log_entries, :destination
  end

  def down
    drop_table :sms_log_entries
  end
end
