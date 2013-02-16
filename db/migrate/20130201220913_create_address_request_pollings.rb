require "migrations/migration_helpers"

class CreateAddressRequestPollings < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_posto_table :address_request_pollings do |t|
      t.integer :address_request_id, null: false, limit: 8
      t.integer :previous_address_request_polling_id, limit: 8
      t.datetime :poll_date, null: false
      t.integer :poll_index, null: false
      t.boolean :latest, null: false

      t.timestamps
    end

    [:address_request_id, :latest].each do |c|
      add_index :address_request_pollings, c
    end

    add_index :address_request_pollings,
              :previous_address_request_polling_id,
              :name => "address_req_polling_previous_idx"
  end

  def down
    drop_table :address_request_pollings
  end
end
