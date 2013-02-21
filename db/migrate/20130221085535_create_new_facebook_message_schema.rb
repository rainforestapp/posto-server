require "migrations/migration_helpers"

class CreateNewFacebookMessageSchema < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_posto_table :address_request_facebook_threads do |t|
      t.integer :address_request_id, null: false, limit: 8
      t.string :facebook_thread_id, null: false
      t.datetime :thread_update_time, null: false
      t.boolean :latest, null: false

      t.timestamps
    end

    add_index :address_request_facebook_threads, :facebook_thread_id

    drop_table :address_request_expirations
    drop_table :address_request_pollings
    drop_table :address_responses
  end

  def down
    drop_table :address_request_facebook_thread
  end
end
