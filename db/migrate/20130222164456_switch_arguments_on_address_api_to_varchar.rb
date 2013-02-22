class SwitchArgumentsOnAddressApiToVarchar < ActiveRecord::Migration
  def up
    remove_column :address_api_responses, :arguments
    add_column :address_api_responses, :arguments, :string, limit: 512, null: false
    add_index :address_api_responses, :arguments
  end

  def down
    remove_column :address_api_responses, :arguments
    add_column :address_api_responses, :arguments, :string, limit: 512, null: false
    add_index :address_api_responses, :arguments
  end
end
