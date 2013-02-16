require "migrations/migration_helpers"

class CreateApps < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_posto_table :apps do |t|
      t.string :name

      t.timestamps
    end

    execute 'insert into apps (name, created_at, updated_at) values (\'lulcards\', now(), now())'
  end

  def down
    drop_table :apps
  end
end
