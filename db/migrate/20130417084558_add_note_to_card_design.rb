class AddNoteToCardDesign < ActiveRecord::Migration
  def change
    add_column :card_designs, :note, :string, limit: 1024
  end
end
