require "migrations/migration_helpers"

class CreateUserLogins < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_sharded_table :user_logins do |t|
      t.integer :user_id, limit: 8, null: false
      t.integer :app_id, limit: 8, null: false
      t.boolean :latest, null: false

      t.timestamps
    end

    add_index :user_logins, :user_id
  end

  def down
    drop_table :user_logins
  end
end
