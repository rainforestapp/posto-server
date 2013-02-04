class StripeCustomer < ActiveRecord::Base
  include AppendOnlyModel
  #attr_accessible :stripe_customer_id, :user_id
end
