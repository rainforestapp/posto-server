class AddCardDesignToCardOrder < ActiveRecord::Migration
  def change
    add_column :card_orders, :card_design_id, :integer, limit: 8, null:false
    add_index :card_orders, :card_design_id
  end
end
