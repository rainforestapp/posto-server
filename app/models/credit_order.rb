class CreditOrder < ActiveRecord::Base
  include AppendOnlyModel
  include TransactionRetryable

  attr_accessible :app_id, :credits, :price

  belongs_to :app
  belongs_to :user
end
