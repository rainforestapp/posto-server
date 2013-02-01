require "migrations/migration_helpers"

class CreateCardPrintings < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_sharded_table :card_printings do |t|
      t.integer :card_order_id, null: false, limit: 8
      t.integer :recipient_user_id, null: false, limit: 8
      t.integer :printed_image_id, null: false, limit: 8
      t.integer :print_number, null: false, limit: 8

      t.timestamps
    end

    [:card_order_id, :recipient_user_id, :printed_image_id, :print_number].each do |c|
       add_index :card_printings, c
    end

    execute "create sequence card_printing_print_number_seq"
    execute "alter table card_printings alter column print_number set default nextval('card_printing_print_number_seq')"
    execute "select setval ('card_printing_print_number_seq', 1000)"
  end

  def down
    drop_table :card_printings
    execute "drop sequence card_printing_print_number_seq"
  end
end
