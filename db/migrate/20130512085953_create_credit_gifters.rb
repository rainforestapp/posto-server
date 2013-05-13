require "migrations/migration_helpers"

class CreateCreditGifters < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_posto_table :people do |t|
      t.string :email, null: false, limit: 512
      t.string :uid, null: false, limit: 512
      t.timestamps
    end

    create_posto_table :person_profiles do |t|
      t.integer :person_id, limit: 8
      t.string :name, null: false
      t.boolean :latest, null: false
      t.timestamps
    end

    create_posto_table :person_notification_preferences do |t|
      t.integer :person_id, limit: 8
      t.string :notification_type, null: false
      t.integer :target_id, limit: 8
      t.boolean :enabled
      t.timestamps
    end

    add_column :credit_orders, :note, :string, limit: 1024
    add_column :credit_orders, :gifter_person_id, :integer, limit: 8

    add_index :credit_orders, :gifter_person_id
    add_index :people, :email
    add_index :person_profiles, :person_id
    add_index :person_profiles, [:person_id, :latest]
    add_index :person_profiles, :name
    add_index :person_notification_preferences, :person_id
    add_index :person_notification_preferences, :target_id
  end

  def down
    remove_column :credit_orders, :note
    remove_column :credit_orders, :gifter_person_id
    drop_table :people
    drop_table :person_profiles
    drop_table :person_notification_preferences
  end
end
