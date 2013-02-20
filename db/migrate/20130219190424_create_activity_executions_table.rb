require "migrations/migration_helpers"
class CreateActivityExecutionsTable < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_posto_table :activity_executions do |t|
      t.string :worker, null: false
      t.string :method, null: false
      t.string :arguments, null: false

      t.timestamps
    end

    add_index :activity_executions, [:worker, :method, :arguments]
  end

  def down
    drop_table :activity_executions
  end
end
