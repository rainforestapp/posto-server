class AddRedeemedAtToCreditPromos < ActiveRecord::Migration
  def change
    add_column :credit_promos, :redeemed_at, :datetime
  end
end
