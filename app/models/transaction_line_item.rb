class TransactionLineItem < ActiveRecord::Base
  include AppendOnlyModel
  #attr_accessible :currency, :description, :is_credit, :price_units, :transaction_id
end
