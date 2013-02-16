require "migrations/migration_helpers"

class CreateAddressRequestStates < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_posto_table :address_request_states do |t|
      t.integer :address_request_id, null: false, limit: 8
      t.string :state, null: false
      t.boolean :latest, null: false

      t.timestamps
    end

    [:address_request_id, :latest].each do |c|
       add_index :address_request_states, c
    end
  end

  def down
    drop_table :address_request_states
  end
end
