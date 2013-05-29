class EmailOptOut < ActiveRecord::Base
  include AppendOnlyModel
  include HasOneAudited
  include HasAuditedState

  attr_accessible :email_class, :recipient_user_id
  belongs_to :recipient_user, class_name: "User"
  symbolize :email_class, in: OutgoingEmailTask::EMAIL_CLASS_MAP.values.uniq, validate: true
  has_audited_state_through :email_opt_out_state
end
