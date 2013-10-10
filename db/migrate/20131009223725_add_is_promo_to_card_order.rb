class AddIsPromoToCardOrder < ActiveRecord::Migration
  def change
    add_column :card_orders, :is_promo, :boolean
  end
end
