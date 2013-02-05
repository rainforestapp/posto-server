require "migrations/migration_helpers"

class CreateFacebookTokens < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_sharded_table :facebook_tokens do |t|
      t.integer :user_id, null: false, limit: 8
      t.string :token, null: false

      t.timestamps
    end

    [:user_id, :token].each do |c|
       add_index :facebook_tokens, c
    end
  end

  def down
    drop_table :facebook_tokens
  end
end
