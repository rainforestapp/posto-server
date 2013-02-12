class AddQuotedTotalToCardOrders < ActiveRecord::Migration
  def up
    add_column :card_orders, :quoted_total_price, :integer, null: false
  end

  def down
    remove_column :card_orders, :quoted_total_price
  end
end
