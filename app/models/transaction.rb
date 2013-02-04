class Transaction < ActiveRecord::Base
  include AppendOnlyModel
  #attr_accessible :charged_customer_id, :charged_customer_type, :card_order_id, :response, :status
end
