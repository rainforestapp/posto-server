class AddSignupCreditBitToUser < ActiveRecord::Migration
  def change
    add_column :users, :signup_credits_awarded, :boolean, null: true
  end
end
