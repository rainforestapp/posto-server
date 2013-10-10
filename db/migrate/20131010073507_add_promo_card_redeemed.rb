class AddPromoCardRedeemed < ActiveRecord::Migration
  def up
    add_column :users, :redeemed_promo_card, :boolean
  end

  def down
    remove_column :users, :redeemed_promo_card
  end
end
