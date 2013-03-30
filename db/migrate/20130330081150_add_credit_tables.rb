require "migrations/migration_helpers"
class AddCreditTables < ActiveRecord::Migration
  include MigrationHelpers
  def up
    create_posto_table :credit_orders do |t|
      t.integer :user_id, limit: 8, null: false
      t.integer :app_id, limit: 8, null: false
      t.integer :price, null: false
      t.integer :credits, null: false

      t.timestamps
    end

    create_posto_table :credit_journal_entries do |t|
      t.integer :user_id, limit: 8, null: false
      t.integer :app_id, limit: 8, null: false
      t.integer :amount, null: false
      t.string :source_type, limit: 64, null: false
      t.string :source_id, limit: 8, null: false

      t.timestamps
    end

    create_posto_table :card_order_credit_allocations do |t|
      t.integer :card_order_id, limit: 8, null: false
      t.integer :credits_per_card, null: false
      t.integer :credits_per_order, null: false
      t.integer :number_of_credited_cards, null: false
      t.boolean :latest, null: false

      t.timestamps
    end

    add_index :credit_orders, :user_id
    add_index :credit_journal_entries, :user_id
    add_index :credit_journal_entries, [:source_type, :source_id]
    add_index :card_order_credit_allocations, :card_order_id
    add_index :card_order_credit_allocations, [:card_order_id, :latest]
  end

  def down
    drop_table :credit_orders
    drop_table :credit_journal_entries
    drop_table :card_order_credit_allocations
  end
end
