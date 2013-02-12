class AddFrontAndBackImageToCardPrintings < ActiveRecord::Migration
  def up
    add_column :card_printings, :front_image_id, :integer, limit: 8, null: false
    add_column :card_printings, :back_image_id, :integer, limit: 8, null: false

    remove_column :card_printings, :printed_image_id

    add_index :card_printings, :front_image_id
    add_index :card_printings, :back_image_id
  end

  def down
    remove_column :card_printings, :front_image_id
    remove_column :card_printings, :back_image_id
    add_column :card_printings, :printed_image_id, :integer, limit: 8, null: false
  end
end
