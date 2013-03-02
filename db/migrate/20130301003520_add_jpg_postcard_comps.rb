class AddJpgPostcardComps < ActiveRecord::Migration
  def up
    add_column :card_printing_compositions, :jpg_card_front_image_id, :integer, null: false, limit: 8
    add_column :card_printing_compositions, :jpg_card_back_image_id, :integer, null: false, limit: 8
  end

  def down
    remove_column :card_printing_compositions, :jpg_card_front_image_id
    remove_column :card_printing_compositions, :jpg_card_back_image_id
  end
end
