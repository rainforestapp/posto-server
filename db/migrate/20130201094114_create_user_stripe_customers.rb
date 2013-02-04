require "migrations/migration_helpers"

class CreateUserStripeCustomers < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_sharded_table :stripe_customers do |t|
      t.integer :user_id, limit: 8, null: false
      t.string :stripe_customer_id, null: false
      t.boolean :latest, null: false

      t.timestamps
    end

    add_index :stripe_customers, :user_id
    add_index :stripe_customers, :stripe_customer_id
  end

  def down
    drop_table :stripe_customers
  end
end
