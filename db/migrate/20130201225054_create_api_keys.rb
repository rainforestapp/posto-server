require "migrations/migration_helpers"

class CreateApiKeys < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_sharded_table :api_keys do |t|
      t.integer :user_id, null: false, limit: 8
      t.string :token, null: false
      t.datetime :expires_at, null: false

      t.timestamps
    end

    [:user_id, :token].each do |c|
       add_index :api_keys, c
    end
  end

  def down
    drop_table :api_keys
  end
end
