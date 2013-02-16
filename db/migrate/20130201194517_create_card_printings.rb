require "migrations/migration_helpers"

class CreateCardPrintings < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_posto_table :card_printings do |t|
      t.integer :card_order_id, null: false, limit: 8
      t.integer :recipient_user_id, null: false, limit: 8
      t.integer :printed_image_id, null: false, limit: 8
      t.integer :print_number, null: false, limit: 8

      t.timestamps
    end

    [:card_order_id, :recipient_user_id, :printed_image_id, :print_number].each do |c|
       add_index :card_printings, c
    end
  end

  def down
    drop_table :card_printings
  end
end
