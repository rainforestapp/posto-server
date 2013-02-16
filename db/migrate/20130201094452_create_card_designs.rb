require "migrations/migration_helpers"

class CreateCardDesigns < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_posto_table :card_designs do |t|
      t.integer :author_user_id, limit:8, null: false
      t.integer :source_card_design_id, limit:8
      t.integer :app_id, limit:8, null: false
      t.integer :design_type
      t.string :top_caption
      t.string :bottom_caption
      t.string :top_caption_font_size
      t.string :bottom_caption_font_size
      t.integer :original_photo_image_id
      t.integer :original_full_photo_image_id
      t.integer :edited_photo_image_id
      t.integer :editied_full_photo_image_id
      t.integer :printable_image_id
      t.integer :printable_full_image_id

      t.timestamps
    end

    [:author_user_id,
     :source_card_design_id,
     :original_photo_image_id,
     :original_full_photo_image_id,
     :edited_photo_image_id,
     :editied_full_photo_image_id,
     :printable_image_id,
     :printable_full_image_id].each do |c|
       add_index :card_designs, c
    end
  end

  def down
    drop_table :card_designs
  end
end
