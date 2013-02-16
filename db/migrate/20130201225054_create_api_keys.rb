require "migrations/migration_helpers"

class CreateApiKeys < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_posto_table :api_keys do |t|
      t.integer :user_id, null: false, limit: 8
      t.string :token, null: false
      t.datetime :expires_at, null: false
      t.boolean :latest, null: false

      t.timestamps
    end

    [:user_id, :token, :latest].each do |c|
       add_index :api_keys, c
    end
  end

  def down
    drop_table :api_keys
  end
end
