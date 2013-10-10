class AddSendFreePromoCardBit < ActiveRecord::Migration
  def up
    add_column :users, :sent_promo_card, :boolean
  end

  def down
    remove_column :users, :sent_promo_card, :boolean
  end
end
