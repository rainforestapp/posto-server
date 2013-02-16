require "migrations/migration_helpers"

class CreateCardCollectionEntries < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_posto_table :card_collection_entries do |t|
      t.integer :card_design_id, null: false, limit: 8
      t.string :source_type, null: false
      t.integer :source_id, null: false, limit: 8
      t.integer :app_id, null: false, limit: 8
      t.integer :collection_type, null: false

      t.timestamps
    end

    [:card_design_id].each do |c|
       add_index :card_collection_entries, c
    end

    add_index :card_collection_entries, [:source_type, :source_id]

    add_index :card_collection_entries, 
              [:card_design_id, :app_id, :collection_type],
              :name => "card_collection_entry_unique_idx",
              :unique => true
  end

  def down
    drop_table :card_collection_entries
  end
end
