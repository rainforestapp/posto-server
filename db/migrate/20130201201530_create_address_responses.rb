require "migrations/migration_helpers"

class CreateAddressResponses < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_posto_table :address_responses do |t|
      t.integer :address_request_id, null: false, limit: 8
      t.integer :response_sender_user_id, null: false, limit: 8
      t.string :response_source_type, null: false
      t.string :response_source_id, null: false
      t.string :response_raw_text, null: false

      t.timestamps
    end

    [:response_sender_user_id, :address_request_id].each do |c|
       add_index :address_responses, c
    end

    add_index :address_responses, 
              [:response_source_type, :response_source_id],
              :name => "address_response_source_idx"
  end

  def down
    drop_table :address_responses
  end
end
