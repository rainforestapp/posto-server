require "migrations/migration_helpers"

class CreateCardScanAuthors < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_posto_table :card_scan_authors do |t|
      t.integer :card_scan_id, null: false, limit: 8
      t.integer :author_user_id, null: false, limit: 8

      t.timestamps
    end

    [:card_scan_id, :author_user_id].each do |c|
       add_index :card_scan_authors, c
    end
  end

  def down
    drop_table :card_scan_authors
  end
end
