require "migrations/migration_helpers"

class CreateCardScans < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_sharded_table :card_scans do |t|
      t.integer :card_printing_id, null: false, limit: 8
      t.integer :app_id, null: false, limit: 8
      t.datetime :scanned_at, null: false

      t.timestamps
    end

    [:card_printing_id, :scanned_at].each do |c|
       add_index :card_scans, c
    end
  end

  def down
    drop_table :card_scans
  end
end
