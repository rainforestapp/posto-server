require "migrations/migration_helpers"

class AddCardPreviewCompositionTable < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_posto_table :card_preview_compositions do |t|
      t.integer :card_design_id, null: false, limit: 8
      t.integer :card_preview_image_id, null: false, limit: 8

      t.timestamps
    end

    [:card_design_id, :card_preview_image_id].each do |c|
       add_index :card_preview_compositions, c
    end

    remove_column :card_printing_compositions, :card_preview_image_id
  end

  def down
    drop_table :card_preview_compositions
    add_column :card_printing_compositions, :card_preview_image_id, :integer
  end
end
