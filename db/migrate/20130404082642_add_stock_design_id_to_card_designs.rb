class AddStockDesignIdToCardDesigns < ActiveRecord::Migration
  def change
    add_column :card_designs, :stock_design_id, :string, limit: 64
  end
end
