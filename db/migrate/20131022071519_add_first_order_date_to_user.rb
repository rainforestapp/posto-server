class AddFirstOrderDateToUser < ActiveRecord::Migration
  def change
    add_column :users, :first_order_at, :datetime
  end
end
