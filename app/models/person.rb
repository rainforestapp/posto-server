class Person < ActiveRecord::Base
  include AppendOnlyModel
  include HasUid
  include TransactionRetryable
  include HasOneAudited

  attr_accessible :email

  has_one_audited :person_profile
  has_many :person_notification_preferences
end
