class UserReferralState < ActiveRecord::Base
  include AppendOnlyModel
  include AuditedStateModel

  belongs_to_and_marks_latest_within :user_referral
  valid_states :created, :granted
end
