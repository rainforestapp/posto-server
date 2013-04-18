require "migrations/migration_helpers"

class AddBirthdayRequestTables < ActiveRecord::Migration

  include MigrationHelpers

  def up
    create_posto_table :birthday_requests do |t|
      t.integer :request_sender_user_id, null: false, limit: 8
      t.integer :request_recipient_user_id, null: false, limit: 8
      t.integer :app_id, null: false, limit: 8
      t.string :birthday_request_medium, null: false
      t.text :birthday_request_payload, null: false
      t.timestamps
    end

    add_index :birthday_requests, :request_sender_user_id
    add_index :birthday_requests, :request_recipient_user_id

    create_posto_table :birthday_request_facebook_threads do |t|
      t.integer :birthday_request_id, null: false, limit: 8
      t.string :facebook_thread_id, null: false
      t.datetime :thread_update_time, null: false
      t.boolean :latest, null: false
      t.timestamps
    end

    add_index :birthday_request_facebook_threads, :birthday_request_id
    add_index :birthday_request_facebook_threads, :facebook_thread_id

    create_posto_table :birthday_request_states do |t|
      t.integer :birthday_request_id, null: false, limit: 8
      t.string :state, null: false
      t.boolean :latest, null: false
      t.timestamps
    end

    add_index :birthday_request_states, :birthday_request_id

    create_posto_table :birthday_request_responses do |t|
      t.integer :birthday_request_id, limit: 8
      t.integer :recipient_user_id, null: false, limit: 8
      t.integer :sender_user_id, null: false, limit: 8
      t.datetime :birthday, null: false
      t.boolean :latest, null: false
      t.timestamps
    end

    add_index :birthday_request_responses, :birthday_request_id
    add_index :birthday_request_responses, :recipient_user_id
    add_index :birthday_request_responses, :sender_user_id
  end

  def down
    drop_table :birthday_requests
    drop_table :birthday_request_facebook_threads
    drop_table :birthday_request_states
    drop_table :birthday_request_responses
  end
end
