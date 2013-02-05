require "migrations/migration_helpers"

class CreateCardPrintingStates < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_sharded_table :card_printing_states do |t|
      t.integer :card_printing_id, null: false, limit: 8
      t.string :state, null: false
      t.boolean :latest, null: false

      t.timestamps
    end

    [:card_printing_id, :latest].each do |c|
       add_index :card_printing_states, c
    end
  end

  def down
    drop_table :card_printing_states
  end
end
