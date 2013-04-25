module RecipientRequest
  extend ActiveSupport::Concern

  def pending?
    [:outgoing, :sent].include?(self.state) && !expired?
  end

  def outgoing?
    self.state == :outgoing
  end

  def sent?
    self.state == :sent
  end

  def expired?
    Time.zone.now > self.created_at + self.expiration_days
  end

  def mark_as_sent!
    self.state = :sent
  end

  def mark_as_closed!
    self.state = :closed
  end

  def mark_as_failed!(*args)
    metadata = args.extract_options!
    self.append_to_metadata!(metadata) if metadata
    self.state = :failed
  end

  def send!
    CONFIG.for_app(self.app) do |config|
      access_token = self.request_sender_user.facebook_token.token
      from_jid = "-#{self.request_sender_user.facebook_id}@chat.facebook.com"
      to_jid = "-#{self.request_recipient_user.facebook_id}@chat.facebook.com"
      body = self.payload[:message]
      message = Jabber::Message.new(to_jid, body)
      client = Jabber::Client.new(Jabber::JID.new(from_jid))
      client.connect
      xfb = Jabber::SASL::XFacebookPlatform.new(client, config.facebook_app_id, access_token, config.facebook_api_secret)
      client.auth_sasl(xfb, nil)
      client.send(message)
      client.close
      mark_as_sent!
      true
    end
  end

  # returns true if new activity was seen
  def mark_facebook_thread_activity_as_latest!
    current_thread = self.facebook_thread
    new_update_time = get_last_recipient_message_sent_time 
    has_new_activity = new_update_time && new_update_time > current_thread.thread_update_time

    if has_new_activity
      self.facebook_threads.create!(
        facebook_thread_id: current_thread.facebook_thread_id,
        thread_update_time: new_update_time
      )
    end

    has_new_activity
  end

  def has_new_facebook_thread_activity?
    unless self.facebook_thread
      init_facebook_thread!
    else
      mark_facebook_thread_activity_as_latest!
    end
  end

  def get_latest_recipient_messages
    unless self.facebook_thread
      init_facebook_thread!
    end

    api = Koala::Facebook::API.new(self.request_sender_user.facebook_token.token)
    recipient_facebook_id = self.request_recipient_user.facebook_id

    thread_id = self.facebook_thread.facebook_thread_id
    messages = api.fql_query("select author_id, body, created_time from message where thread_id = #{thread_id}")

    messages.select do |m|
      m["author_id"].to_s == recipient_facebook_id
    end
  end

  def send_sender_notification(message)
    self.request_sender_user.send_notification(message, app: self.app)
  end

  private

  # Returns true if there have been messages since our original request was sent
  def init_facebook_thread!
    sender_facebook_id = self.request_sender_user.facebook_id
    recipient_facebook_id = self.request_recipient_user.facebook_id

    api = Koala::Facebook::API.new(self.request_sender_user.facebook_token.token)
    sent_message_text = self.payload[:message].gsub(/\s+$/, "")

    threads = api.fql_query("select thread_id, recipients, updated_time from thread where folder_id = 0 and #{recipient_facebook_id} IN recipients order by updated_time desc")

    request_facebook_thread = nil
    request_message = nil

    loop do
      threads.each do |thread|
        next unless thread["recipients"] && thread["recipients"].size == 2

        messages = api.fql_query("select author_id, body, created_time from message where thread_id = #{thread["thread_id"]} order by created_time desc")

        matching_message = messages.find do |message|
          has_author = message["author_id"].to_s == sender_facebook_id
          has_body = message["body"].downcase.include?(sent_message_text.downcase)
          has_author && has_body
        end

        if matching_message
          request_facebook_thread = thread
          request_message = matching_message
          break
        end

        messages = messages.next_page
        break if messages.blank?
      end

      break if request_facebook_thread

      threads = threads.next_page
      break if threads.blank?
    end

    if request_facebook_thread
      thread_update_time = Time.at(request_facebook_thread["updated_time"])
      request_sent_time = Time.at(request_message["created_time"])

      self.facebook_threads.create!(
        facebook_thread_id: request_facebook_thread["thread_id"],
        thread_update_time: thread_update_time
      )

      return thread_update_time > request_sent_time
    else
      false
    end
  end

  def get_last_recipient_message_sent_time
    recipient_messages = get_latest_recipient_messages
    return nil if recipient_messages.size == 0

    last_recipient_message_time = recipient_messages.map { |r| r["created_time"] }.max
    return Time.at(last_recipient_message_time)
  end

  module ClassMethods
  end
end
