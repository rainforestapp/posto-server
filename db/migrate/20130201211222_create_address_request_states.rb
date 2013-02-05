require "migrations/migration_helpers"

class CreateAddressRequestStates < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_sharded_table :address_request_states do |t|
      t.integer :address_request_id, null: false, limit: 8
      t.string :state, null: false
      t.boolean :latest, null: false

      t.timestamps
    end

    [:address_request_id, :latest].each do |c|
       add_index :address_request_states, c
    end

    execute "create index address_request_states_state_latest_idx on address_request_states (state, latest) where latest = 't'"
  end

  def down
    drop_table :address_request_states
  end
end
