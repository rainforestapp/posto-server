require "migrations/migration_helpers"

class CreateAddressApiResponses < ActiveRecord::Migration
  include MigrationHelpers

  def up
    execute "create extension if not exists hstore"

    create_sharded_table :address_api_responses do |t|
      t.hstore :arguments, null: false
      t.hstore :response, null: false
      t.string :api_type, null: false

      t.timestamps
    end

    execute "create index arguments_idx on address_api_responses using gin(arguments)"
    execute "create index response_idx on address_api_responses using gin(response)"
  end

  def down
    drop_table :address_api_responses
  end
end
