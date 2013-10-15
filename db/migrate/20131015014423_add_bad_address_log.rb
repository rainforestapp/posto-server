require "migrations/migration_helpers"

class AddBadAddressLog < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_posto_table :address_request_error_log_entries do |t|
      t.string :q, null: false, limit: 2048
      t.timestamps
    end
  end

  def down
    drop_table :address_request_error_log_entries
  end
end
