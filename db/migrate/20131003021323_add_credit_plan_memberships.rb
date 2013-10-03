require "migrations/migration_helpers"

class AddCreditPlanMemberships < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_posto_table :credit_plan_memberships do |t|
      t.integer :user_id, null: false, limit: 8
      t.integer :app_id, null: false, limit: 8
      t.integer :credit_plan_id, null: false, limit: 8
      t.integer :credit_plan_credits, null: false
      t.integer :credit_plan_price, null: false
      t.timestamps
    end

    add_index :credit_plan_memberships, :user_id
    add_index :credit_plan_memberships, :created_at

    create_posto_table :credit_plan_membership_states do |t|
      t.integer :credit_plan_membership_id, null: false, limit: 8
      t.string :state, null: false, limit: 64
      t.boolean :latest, null: false
      t.timestamps
    end

    add_index :credit_plan_membership_states, :credit_plan_membership_id

    create_posto_table :credit_plan_payments do |t|
      t.integer :credit_plan_membership_id, null: false, limit: 8
      t.datetime :due_date, null: false
      t.timestamps
    end

    add_index :credit_plan_payments, :credit_plan_membership_id
    add_index :credit_plan_payments, :due_date

    create_posto_table :credit_plan_payment_states do |t|
      t.integer :credit_plan_payment_id, null: false, limit: 8
      t.string :state, null: false, limit: 64
      t.boolean :latest, null: false
      t.timestamps
    end

    add_index :credit_plan_payment_states, :credit_plan_payment_id
  end

  def down
    drop_table :credit_plan_memberships
    drop_table :credit_plan_membership_states
    drop_table :credit_plan_payments
    drop_table :credit_plan_payment_states
  end
end
