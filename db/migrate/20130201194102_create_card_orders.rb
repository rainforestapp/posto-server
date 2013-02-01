require "migrations/migration_helpers"

class CreateCardOrders < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_sharded_table :card_orders do |t|
      t.integer :sender_user_id, null: false, limit:8
      t.integer :app_id, null:false, limit:8

      t.timestamps
    end

    [:sender_user_id].each do |c|
       add_index :card_orders, c
    end
  end

  def down
    drop_table :card_orders
  end
end
