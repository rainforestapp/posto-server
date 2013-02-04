require "migrations/migration_helpers"

class CreateUsers < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_sharded_table :users do |t|
      t.string :facebook_id, null: false
      t.string :name, null: false
      t.string :first_name
      t.string :last_name
      t.string :location
      t.string :middle_name
      t.datetime :birthday
      t.string :gender

      t.timestamps
    end

    add_index :users, :facebook_id, :unique => true
  end

  def down
    drop_table :users
  end
end
