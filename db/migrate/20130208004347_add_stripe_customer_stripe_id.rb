class AddStripeCustomerStripeId < ActiveRecord::Migration
  def up
    add_column :stripe_customers, :stripe_id, :string, null: false
    add_index :stripe_customers, :stripe_id
    execute "alter table stripe_customers modify column stripe_customer_id bigint not null auto_increment"
  end

  def down
    remove_column :stripe_customers, :stripe_id
    execute "alter table stripe_customers modify column stripe_customer_id bigint not null"
  end
end
