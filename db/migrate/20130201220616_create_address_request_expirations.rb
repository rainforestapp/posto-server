require "migrations/migration_helpers"

class CreateAddressRequestExpirations < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_posto_table :address_request_expirations do |t|
      t.integer :address_request_id, null: false, limit: 8
      t.integer :duration_hit_hours, null: false
      t.integer :duration_limit_hours, null: false

      t.timestamps
    end

    add_index :address_request_expirations, :address_request_id, :unique => true
  end

  def down
    drop_table :address_request_expirations
  end
end
