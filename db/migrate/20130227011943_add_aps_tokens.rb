require "migrations/migration_helpers"

class AddApsTokens < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_posto_table :aps_tokens do |t|
      t.integer :user_id, null: false, limit: 8
      t.integer :app_id, null: false, limit: 8
      t.string :token, null: false, limit: 512
    end

    add_index :aps_tokens, :token
    add_index :aps_tokens, :user_id
  end

  def down
    drop_table :aps_tokens
  end
end
