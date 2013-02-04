require "migrations/migration_helpers"

class CreateCardOrderStates < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_sharded_table :card_order_states do |t|
      t.integer :card_order_id, null: false, limit: 8
      t.string :state, null: false
      t.boolean :latest, null: false

      t.timestamps
    end

    [:card_order_id].each do |c|
       add_index :card_order_states, c
    end
  end

  def down
    drop_table :card_order_states
  end
end
