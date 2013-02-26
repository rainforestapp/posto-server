class TransactionLineItem < ActiveRecord::Base
  include AppendOnlyModel
  attr_accessible :description, :price_units, :currency, :is_credit
end
