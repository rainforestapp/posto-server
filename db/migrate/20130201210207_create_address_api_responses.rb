require "migrations/migration_helpers"

class CreateAddressApiResponses < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_posto_table :address_api_responses do |t|
      t.text :arguments, null: false
      t.text :response, null: false
      t.string :api_type, null: false

      t.timestamps
    end
  end

  def down
    drop_table :address_api_responses
  end
end
