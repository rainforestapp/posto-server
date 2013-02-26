class Transaction < ActiveRecord::Base
  include AppendOnlyModel

  attr_accessible :charged_customer_type, :charged_customer_id, :response

  serialize :response, Hash
  symbolize :charged_customer_type, in: [:stripe], validates: true

  has_many :transaction_line_items
end
