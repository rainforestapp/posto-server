require "migrations/migration_helpers"

class CreateTransactionLineItems < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_sharded_table :transaction_line_items do |t|
      t.integer :transaction_id, null: false, limit: 8
      t.string :description, null: false
      t.integer :price_units, null: false
      t.string :currency, null: false
      t.boolean :is_credit, null: false, default: false

      t.timestamps
    end

    [:transaction_id].each do |c|
       add_index :transaction_line_items, c
    end
  end

  def down
    drop_table :transaction_line_items
  end
end
