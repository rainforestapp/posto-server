require "migrations/migration_helpers"

class CreateFacebookTokenStates < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_posto_table :facebook_token_states do |t|
      t.integer :facebook_token_id, null: false, limit: 8
      t.string :state, null: false
      t.boolean :latest, null: false

      t.timestamps
    end

    [:facebook_token_id, :latest].each do |c|
       add_index :facebook_token_states, c
    end
  end

  def down
    drop_table :facebook_token_states
  end
end
