class AddressRequest < ActiveRecord::Base
  include AppendOnlyModel
  include HasOneAudited
  include HasAuditedState

  attr_accessible :request_recipient_user, :app, :address_request_medium, :address_request_payload, :state

  belongs_to :request_sender_user, class_name: "User"
  belongs_to :request_recipient_user, class_name: "User"
  belongs_to :app

  has_audited_state_through :address_request_state

  symbolize :address_request_medium, in: [:facebook_message], validate: true
  serialize :address_request_payload, Hash

  before_create :ensure_no_other_pending_request_for_recipient

  has_one_audited :address_request_facebook_thread

  def expirable?
    return false unless self.pending?

    Time.zone.now > self.created_at + CONFIG.address_request_expiration_days.days
  end

  def pending?
    [:outgoing, :sent].include?(self.state)
  end

  def check_and_expire!
    return false unless expirable?

    self.state = :expired
  end

  def mark_as_sent!
    self.state = :sent
  end

  def mark_as_failed!(*args)
    metadata = args.extract_options!
    self.append_to_metadata!(metadata) if metadata
    self.state = :failed
  end

  def close_with_api_response(address_api_response)
    self.request_recipient_user.recipient_addresses.create!(
      address_api_response: address_api_response,
      address_request: self
    )

    self.state = :closed
  end

  def ensure_no_other_pending_request_for_recipient
    if self.request_recipient_user.has_pending_address_request?
      raise "Pending address request already exists for #{self.request_recipient_user}"
    end
  end

  # returns true if new activity was seen
  def mark_facebook_thread_activity_as_latest!
    current_thread = self.address_request_facebook_thread
    new_update_time = get_last_recipient_message_sent_time 
    has_new_activity = new_update_time && new_update_time > current_thread.thread_update_time

    if has_new_activity
      self.address_request_facebook_threads.create!(
        facebook_thread_id: current_thread.facebook_thread_id,
        thread_update_time: new_update_time
      )
    end

    has_new_activity
  end

  def has_new_facebook_thread_activity?
    unless self.address_request_facebook_thread
      init_address_request_facebook_thread!
    else
      mark_facebook_thread_activity_as_latest!
    end
  end

  def get_latest_recipient_messages
    unless self.address_request_facebook_thread
      init_address_request_facebook_thread!
    end

    api = Koala::Facebook::API.new(self.request_sender_user.facebook_token.token)
    recipient_facebook_id = self.request_recipient_user.facebook_id

    thread_id = self.address_request_facebook_thread.facebook_thread_id
    messages = api.fql_query("select author_id, body, created_time from message where thread_id = #{thread_id}")

    messages.select do |m|
      m["author_id"].to_s == recipient_facebook_id
    end
  end

  private

  # Returns true if there have been messages since our original request was sent
  def init_address_request_facebook_thread!
    sender_facebook_id = self.request_sender_user.facebook_id
    recipient_facebook_id = self.request_recipient_user.facebook_id

    api = Koala::Facebook::API.new(self.request_sender_user.facebook_token.token)
    sent_message_text = self.address_request_payload[:message].gsub(/\s+$/, "")

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

      self.address_request_facebook_threads.create!(
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
end
