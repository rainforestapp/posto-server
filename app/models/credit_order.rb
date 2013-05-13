class CreditOrder < ActiveRecord::Base
  include AppendOnlyModel
  include TransactionRetryable

  attr_accessible :app_id, :credits, :price, :gifter_person_id, :note

  belongs_to :app
  belongs_to :user
  belongs_to :gifter_person, class_name: "Person"
end
