class OutgoingEmailTask < ActiveRecord::Base
  include AppendOnlyModel
  include HasOneAudited
  include HasAuditedState
  include HasUid
  include TransactionRetryable

  EMAIL_CLASS_MAP = {
    birthday_reminder: :reminders,
    inactive_beckon: :drip,
  }

  attr_accessible :app_id, :workload_id, :workload_index, :email_type, :email_variant, :email_args, :recipient_user_id
  belongs_to :recipient_user, class_name: "User"
  belongs_to :app
  symbolize :email_type, in: EMAIL_CLASS_MAP.keys, validate: true
  serialize :email_args, Hash

  has_audited_state_through :outgoing_email_task_state

  def has_been_sent?
    self.state != :outgoing
  end
end
