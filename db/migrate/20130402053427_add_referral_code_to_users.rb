class AddReferralCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :uid, :string, null: false
    add_index :users, :uid
  end
end
