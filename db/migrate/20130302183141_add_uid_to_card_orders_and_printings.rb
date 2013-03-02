class AddUidToCardOrdersAndPrintings < ActiveRecord::Migration
  def change
    add_column :card_orders, :uid, :string, null: false
    add_column :card_printings, :uid, :string, null: false

    add_index :card_orders, :uid, unique: true
    add_index :card_printings, :uid, unique: true
  end
end
