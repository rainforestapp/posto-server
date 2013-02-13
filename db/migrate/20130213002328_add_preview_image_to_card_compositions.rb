class AddPreviewImageToCardCompositions < ActiveRecord::Migration
  def change
    add_column :card_printing_compositions, :card_preview_image_id, :integer, null: false, limit: 8
    add_index :card_printing_compositions, :card_preview_image_id
  end
end
