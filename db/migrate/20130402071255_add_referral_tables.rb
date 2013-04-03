require "migrations/migration_helpers"
class AddReferralTables < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_posto_table :user_referrals do |t|
      t.integer :referred_user_id, limit: 8, null: false
      t.integer :referring_user_id, limit: 8, null: false
      t.integer :app_id, limit: 8, null: false

      t.timestamps
    end

    add_index :user_referrals, :referred_user_id
    add_index :user_referrals, :referring_user_id

    create_posto_table :user_referral_states do |t|
      t.integer :user_referral_id, limit: 8, null: false
      t.string :state, null: false
      t.boolean :latest, null: false

      t.timestamps
    end

    add_index :user_referral_states, :user_referral_id
    add_index :user_referral_states, [:user_referral_id, :latest]
  end

  def down
    drop_table :user_referrals
    drop_table :user_referral_states
  end
end
