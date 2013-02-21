class AddLatestColumnToCardPrintings < ActiveRecord::Migration
  def change
    add_column :card_printing_compositions, :latest, :boolean, null: false
  end
end
