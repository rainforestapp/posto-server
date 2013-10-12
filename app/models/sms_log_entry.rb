class SmsLogEntry < ActiveRecord::Base
  include AppendOnlyModel
  include TransactionRetryable

  attr_accessible :app_id, :sms_type, :destination, :message

  belongs_to :app

  symbolize :sms_type, in: [:onboard], validates: true

  def self.may_send_sms_to?(destination)
    SmsLogEntry.transaction_with_retry do
      current_entries = SmsLogEntry.where(destination: destination)
      return current_entries.size < CONFIG.max_sms_messages_per_destination
    end

    return false
  end
end

