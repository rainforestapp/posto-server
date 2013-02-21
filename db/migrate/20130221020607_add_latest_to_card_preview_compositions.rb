class AddLatestToCardPreviewCompositions < ActiveRecord::Migration
  def change
    add_column :card_preview_compositions, :latest, :boolean, null: false
  end
end
