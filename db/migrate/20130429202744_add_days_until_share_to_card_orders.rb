class AddDaysUntilShareToCardOrders < ActiveRecord::Migration
  def change
    add_column :card_orders, :days_until_share, :integer
  end
end
