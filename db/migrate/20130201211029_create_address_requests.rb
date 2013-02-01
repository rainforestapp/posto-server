require "migrations/migration_helpers"

class CreateAddressRequests < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_sharded_table :address_requests do |t|
      t.integer :sender_user_id, null: false, limit: 8
      t.integer :recipient_user_id, null: false, limit: 8
      t.integer :app_id, null: false, limit: 8
      t.string :address_request_medium, null: false
      t.hstore :address_request_payload, null: false

      t.timestamps
    end

    [:sender_user_id, :recipient_user_id].each do |c|
       add_index :address_requests, c
    end
  end

  def down
    drop_table :address_requests
  end
end
