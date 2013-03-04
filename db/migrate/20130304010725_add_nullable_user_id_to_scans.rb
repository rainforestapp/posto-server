class AddNullableUserIdToScans < ActiveRecord::Migration
  def change
    add_column :card_scans, :scanned_by_user_id, :integer, limit: 8
    add_column :card_scans, :latest, :boolean, null: false
    add_index :card_scans, :scanned_by_user_id
    add_index :card_scans, :device_uuid
  end
end
