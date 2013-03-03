class AddAdditionalDataToCardScans < ActiveRecord::Migration
  def change
    add_column :card_scans, :scan_position, :string, null: false
    add_column :card_scans, :device_uuid, :string, null: false
  end
end
