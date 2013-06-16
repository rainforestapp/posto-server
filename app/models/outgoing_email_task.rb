class OutgoingEmailTask < ActiveRecord::Base
  include AppendOnlyModel
  include HasOneAudited
  include HasAuditedState
  include HasUid
  include TransactionRetryable

  EMAIL_CLASS_MAP = {
    birthday_reminder: :reminders,
    drip_1_day: :drip,
    drip_1_week: :drip,
    drip_3_week: :drip,
    drip_8_week: :drip,
    drip_12_week: :drip,
    drip_welcome: :drip,
    thank_you: :thank_you
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
    sent_already = false

    OutgoingEmailTask.transaction_with_retry do
      sent_already = has_been_sent?
    end

    return if sent_already

    email_class = EMAIL_CLASS_MAP[self.email_type]

    mailer_klass = nil

    case email_class
    when :reminders
      mailer_klass = ReminderMailer
    when :drip
      mailer_klass = DripMailer
    when :thank_you
      mailer_klass = ThankYouMailer
    else
      raise "No mailer for #{email_class}"
    end

    params = { outgoing_email_task: self }.merge(self.email_args)
    mail = mailer_klass.send(self.email_type, params)

    if mail
      begin
        mail.deliver
      rescue Exception => e
        OutgoingEmailTask.transaction_with_retry do
          self.state = :failed
        end
      end

      OutgoingEmailTask.transaction_with_retry do
        self.state = :sent
      end
    else
      OutgoingEmailTask.transaction_with_retry do
        self.state = :failed
      end
    end
  end
end
