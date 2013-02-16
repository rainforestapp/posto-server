require "migrations/migration_helpers"

class CreateCardPrintingCompositions < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_posto_table :card_printing_compositions do |t|
      t.integer :card_printing_id, null: false, limit: 8
      t.integer :card_front_image_id, null: false, limit: 8
      t.integer :card_back_image_id, null: false, limit: 8

      t.timestamps
    end

    [:card_printing_id, :card_front_image_id, :card_back_image_id].each do |c|
       add_index :card_printing_compositions, c
    end
  end

  def down
    drop_table :card_printing_compositions
  end
end
