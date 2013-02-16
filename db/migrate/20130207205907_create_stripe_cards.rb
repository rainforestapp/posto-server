require "migrations/migration_helpers"

class CreateStripeCards < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_posto_table :stripe_cards do |t|
      t.integer :exp_month, null: false
      t.integer :exp_year, null: false
      t.string :fingerprint, null: false
      t.string :last4, null: false
      t.string :card_type, null: false
      t.timestamps
    end

    add_index :stripe_cards, :fingerprint, :unique => true

    create_posto_table :stripe_customer_cards do |t|
      t.integer :stripe_customer_id, null: false, limit: 8
      t.integer :stripe_card_id, null: false, limit: 8
      t.boolean :latest, null: false
      t.timestamps
    end

    [:stripe_customer_id, :stripe_card_id].each do |column|
      add_index :stripe_customer_cards, column
    end

    create_posto_table :stripe_customer_card_states do |t|
      t.integer :stripe_customer_card_id, limit: 8, null: false
      t.string :state, null: false
      t.boolean :latest, null: false
      t.timestamps
    end

    [:stripe_customer_card_id].each do |column|
      add_index :stripe_customer_card_states, column
    end
  end

  def down
    drop_table :stripe_cards
    drop_table :stripe_customer_cards
    drop_table :stripe_customer_card_states
  end
end
