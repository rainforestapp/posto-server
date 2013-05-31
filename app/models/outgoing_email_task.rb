class OutgoingEmailTask < ActiveRecord::Base
  include AppendOnlyModel
  include HasOneAudited
  include HasAuditedState
  include HasUid
  include TransactionRetryable

  EMAIL_CLASS_MAP = {
    birthday_reminder: :reminders,
    drip_1_week: :drip,
    drip_3_week: :drip,
    drip_8_week: :drip,
    drip_12_week: :drip,
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

  def send!
    return if has_been_sent?

    email_class = EMAIL_CLASS_MAP[self.email_type]

    mailer_klass = nil

    case email_class
    when :reminders
      mailer_klass = ReminderMailer
    when :drip
      mailer_klass = DripMailer
    else
      raise "No mailer for #{email_class}"
    end

    params = { outgoing_email_task: self }.merge(self.email_args)
    mail = mailer_klass.send(self.email_type, params)

    if mail
      begin
        mail.deliver
      rescue Exception => e
        self.state = :failed
      end

      self.state = :sent
    else
      self.state = :failed
    end
  end
end
