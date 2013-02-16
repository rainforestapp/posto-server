require "migrations/migration_helpers"

class CreateUserProfiles < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_posto_table :user_profiles do |t|
      t.integer :user_id, null: false, limit: 8
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :location
      t.string :middle_name
      t.datetime :birthday
      t.string :gender
      t.string :email
      t.boolean :latest, null: false

      t.timestamps
    end

    [:user_id, :name, :last_name, :email, :latest].each do |c|
       add_index :user_profiles, c
    end

    remove_column :users, :name
    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :location
    remove_column :users, :middle_name
    remove_column :users, :birthday
    remove_column :users, :gender
  end

  def down
    drop_table :user_profiles
    add_column :users, :name, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :location, :string
    add_column :users, :middle_name, :string
    add_column :users, :birthday, :datetime
    add_column :users, :gender, :string
  end
end
