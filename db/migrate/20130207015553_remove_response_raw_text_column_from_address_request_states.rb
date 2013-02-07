class RemoveResponseRawTextColumnFromAddressRequestStates < ActiveRecord::Migration
  def up
    remove_column :address_responses, :response_raw_text
    add_column :address_responses, :response_data, :hstore
  end

  def down
    add_column :address_responses, :response_raw_text, :text
    remove_column :address_responses, :response_data
  end
end
