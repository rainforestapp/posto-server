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
    notifier_klass = nil

    case email_class
    when :reminders
      mailer_klass = ReminderMailer
    when :drip
      mailer_klass = DripMailer
      notifier_klass = DripNotifier
    when :thank_you
      mailer_klass = ThankYouMailer
    else
      raise "No mailer for #{email_class}"
    end

    params = { outgoing_email_task: self }.merge(self.email_args)
    email_ok = true
    notification_ok = true

    if mailer_klass && mailer_klass.respond_to?(self.email_type)
      email_ok = false

      begin
        mail = mailer_klass.send(self.email_type, params)
        mail.try(:deliver)
        email_ok = true
      rescue Exception => e
        Airbrake.notify_or_ignore(e, parameters: {})
      end
    end

    if notifier_klass && notifier_klass.respond_to?(self.email_type)
      notification_ok = false

      begin
        notifier_klass.send(self.email_type, params)
        notification_ok = true
      rescue Exception => e
        Airbrake.notify_or_ignore(e, parameters: {})
      end
    end

    OutgoingEmailTask.transaction_with_retry do
      if email_ok && notification_ok
        self.state = :sent
      else
        self.state = :failed
      end
    end
  end
end
