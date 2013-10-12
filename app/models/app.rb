class App < ActiveRecord::Base
  include AppendOnlyModel
  attr_accessible :name
  has_many :sms_log_entries

  def self.lulcards
    @lulcards ||= App.where(name: "lulcards", apple_app_id: "585112745", domain: "lulcards.com").first_or_create!
  end

  def self.babygrams
    @babygrams ||= App.where(name: "babygrams", apple_app_id: "634710276", domain: "babygramsapp.com").first_or_create!
  end

  def self.by_name(name)
    raise "Bad app name #{name}" unless name == "lulcards" || name == "babygrams"
    name == "lulcards" ? self.lulcards : self.babygrams
  end

  def send_sms!(*args)
    options = args.extract_options!
    destination = options[:to]
    raise "bad destination" unless destination =~ /^\d\d\d\d\d\d\d\d\d\d$/

    return false unless SmsLogEntry.may_send_sms_to?(destination)

    sms_type = options[:type] || :onboard
    config = CONFIG.for_app(self)
    message = config.send("sms_#{sms_type}_message".to_sym)
    raise "no message" unless message
    return false if CONFIG.sms_disabled

    self.sms_log_entries.create!(destination: destination,
                                 sms_type: sms_type,
                                 message: message)

    twilio = Twilio::REST::Client.new(config.twilio_account_sid, config.twilio_token)

    twilio.account.messages.create(
      from: config.twilio_from_number,
      to: "+1#{destination}",
      body: message
    )

    return true
  end
end
