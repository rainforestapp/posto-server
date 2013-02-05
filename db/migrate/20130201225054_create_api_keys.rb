require "migrations/migration_helpers"

class CreateApiKeys < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_sharded_table :api_keys do |t|
      t.integer :user_id, null: false, limit: 8
      t.string :token, null: false
      t.datetime :expires_at, null: false
      t.boolean :latest, null: false

      t.timestamps
    end

    [:user_id, :token, :latest].each do |c|
       add_index :api_keys, c
    end

    execute "create index api_key_states_user_id_latest_idx on api_keys (user_id, latest) where latest = 't'"
  end

  def down
    drop_table :api_keys
  end
end
