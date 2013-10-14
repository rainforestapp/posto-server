require "migrations/migration_helpers"

class AddDelayedPromoCards < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_posto_table :delayed_promo_cards do |t|
      t.integer :user_id, null: false, limit: 8
      t.integer :supplied_address_api_response_id, null: false, limit: 8
      t.timestamps
    end

    create_posto_table :delayed_promo_card_states do |t|
      t.integer :delayed_promo_card_id, null: false, limit: 8
      t.string :state, null: false, limit: 64
      t.boolean :latest, null: false
      t.timestamps
    end

    add_index :delayed_promo_cards, :created_at
    add_index :delayed_promo_cards, :user_id
    add_index :delayed_promo_card_states, :delayed_promo_card_id
  end

  def down
    drop_table :delayed_promo_cards
    drop_table :delayed_promo_card_states
  end
end
