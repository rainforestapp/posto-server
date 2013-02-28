class AddBorderedPreviewImageToDesign < ActiveRecord::Migration
  def change
    add_column :card_preview_compositions, :treated_card_preview_image_id, :integer, limit: 8, null: false
  end
end
