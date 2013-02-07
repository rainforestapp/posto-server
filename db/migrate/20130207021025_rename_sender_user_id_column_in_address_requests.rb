class RenameSenderUserIdColumnInAddressRequests < ActiveRecord::Migration
  def up
    rename_column :address_requests, :sender_user_id, :request_sender_user_id
    rename_column :address_requests, :recipient_user_id, :request_recipient_user_id
    rename_column :card_orders, :sender_user_id, :order_sender_user_id
  end

  def down
    rename_column :address_requests, :request_sender_user_id, :sender_user_id
    rename_column :address_requests, :request_recipient_user_id, :recipient_user_id
    rename_column :card_orders, :order_sender_user_id, :sender_user_id
  end
end
