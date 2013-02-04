require "migrations/migration_helpers"

class CreateRecipientAddresses < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_sharded_table :recipient_addresses do |t|
      t.integer :recipient_user_id, null: false, limit: 8
      t.integer :address_api_response_id, null: false, limit: 8
      t.boolean :latest, null: false

      t.timestamps
    end

    [:recipient_user_id, :address_api_response_id].each do |c|
       add_index :recipient_addresses, c
    end
  end

  def down
    drop_table :recipient_addresses
  end
end
