class AddPromoCodeTypeAndRecipient < ActiveRecord::Migration
  def up
    add_column :credit_promos, :credit_promo_type, :string, null: false
    CreditPromo.connection.execute("UPDATE credit_promos set credit_promo_type = 'ad_hoc'")

    add_column :credit_promos, :intended_recipient_user_id, :integer, limit: 8
  end

  def down
    remove_column :credit_promos, :credit_promo_type
    remove_column :credit_promos, :intended_recipient_user_id
  end
end
