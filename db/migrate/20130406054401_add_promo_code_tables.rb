require "migrations/migration_helpers"

class AddPromoCodeTables < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_posto_table :credit_promos do |t|
      t.string :uid, limit: 64, null: false
      t.integer :granted_to_user_id, limit: 8
      t.integer :credits, null: false
      t.integer :app_id, null: false, limit: 8

      t.timestamps
    end

    create_posto_table :credit_promo_states do |t|
      t.string :state, limit: 64, null: false
      t.integer :credit_promo_id, limit: 8, null:false
      t.boolean :latest, null: false

      t.timestamps
    end

    [:uid, :granted_to_user_id].each do |c|
       add_index :credit_promos, c
    end

    [:credit_promo_id].each do |c|
       add_index :credit_promo_states, c
    end
  end

  def down
    drop_table :credit_promos
    drop_table :credit_promo_states
  end
end
