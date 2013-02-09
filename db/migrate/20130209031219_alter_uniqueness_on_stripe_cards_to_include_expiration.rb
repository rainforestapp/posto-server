class AlterUniquenessOnStripeCardsToIncludeExpiration < ActiveRecord::Migration
  def up
    remove_index :stripe_cards, :fingerprint
    add_index :stripe_cards, [:fingerprint, :exp_month, :exp_year], :unique => true
  end

  def down
    add_index :stripe_cards, :fingerprint, :unique => true
    remove_index :stripe_cards, [:fingerprint, :exp_month, :exp_year]
  end
end
