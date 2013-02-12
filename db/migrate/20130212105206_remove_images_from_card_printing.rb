class RemoveImagesFromCardPrinting < ActiveRecord::Migration
  def up
    remove_column :card_printings, :front_image_id
    remove_column :card_printings, :back_image_id
  end

  def down
    add_column :card_printings, :front_image_id, :integer, limit: 8, null: false
    add_column :card_printings, :back_image_id, :integer, limit: 8, null: false
  end
end
