require "migrations/migration_helpers"

class CreateTransactions < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_sharded_table :transactions do |t|
      t.integer :card_order_id, null: false, limit: 8
      t.string :charged_customer_type, null: false
      t.integer :charged_customer_id, null: false, limit: 8
      t.hstore :response, null: false
      t.string :status, null: false

      t.timestamps
    end

    [:card_order_id].each do |c|
       add_index :transactions, c
    end

    add_index :transactions, 
              [:charged_customer_type, :charged_customer_id],
              :name => "transaction_customer_idx"
  end

  def down
    drop_table :transactions
  end
end
