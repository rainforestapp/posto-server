class AddSenderSuppliedAddressApiResponseId < ActiveRecord::Migration
  def up
    add_column :address_requests, :sender_supplied_address_api_response_id, :integer, limit: 8
  end

  def down
    remove_column :address_requests, :sender_supplied_address_api_response_id
  end
end
