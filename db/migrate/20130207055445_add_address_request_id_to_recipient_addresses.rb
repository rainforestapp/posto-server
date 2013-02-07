class AddAddressRequestIdToRecipientAddresses < ActiveRecord::Migration
  def up
    add_column :recipient_addresses, :address_request_id, :integer, limit:8, null:false
    add_index :recipient_addresses, :address_request_id
  end

  def down
    remove_column :recipient_addresses, :address_request_id
  end
end
