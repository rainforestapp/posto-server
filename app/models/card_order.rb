class CardOrder < ActiveRecord::Base
  include AppendOnlyModel
  include HasAuditedState
  include HasOneAudited
  include HasUid
  include TransactionRetryable

  attr_accessible :app, :quoted_total_price, :card_design, :is_promo

  belongs_to :order_sender_user, class_name: "User"
  belongs_to :app
  belongs_to :card_design

  has_many :card_printings
  has_many :transactions, order: "created_at desc"

  has_audited_state_through :card_order_state
  has_one_audited :card_order_credit_allocation

  after_create :update_author_promo_bit

  def mark_as_cancelled!
    self.card_printings.each(&:mark_as_cancelled!)
    self.refund_all_allocated_credits!
    self.state = :cancelled
  end

  def mark_as_finished!
    self.state = :finished
  end

  def mark_as_failed!
    self.state = :failed
  end

  def mailable_card_printings
    self.card_printings.select(&:mailable?)
  end

  def has_unmailable_printing?
    self.card_printings.reject(&:mailable?).size > 0
  end

  def number_of_mailable_cards
    mailable_card_printings.size
  end

  def number_of_ordered_cards
    self.card_printings.size
  end

  def number_of_payable_mailable_cards
    [number_of_mailable_cards - number_of_credit_allocated_cards, 0].max
  end

  def total_price_to_charge_for_number_of_cards(number_of_cards)
    return 0 if number_of_cards == 0 || self.is_promo

    CONFIG.for_app(self.app) do |config|
      config.processing_fee + (config.card_fee * number_of_cards)
    end
  end

  def total_price_to_charge
    total_price_to_charge_for_number_of_cards(self.number_of_payable_mailable_cards)
  end

  def printable_total_price
    "$%.02f" % (total_price_to_charge / 100.0) 
  end

  def order_number
    10000 + (self.card_order_id * 17)
  end

  def send_order_notification(message)
    self.order_sender_user.send_notification(message, app: self.app)
  end

  def execute_workflow!
    swf = AWS::SimpleWorkflow.new
    domain = swf.domains["posto-#{Rails.env == "production" ? "prod" : "dev"}"]
    workflow_type = domain.workflow_types['CardOrderWorkflow.processOrder', CONFIG.for_app(self.app).order_workflow_version]
    input = ["[Ljava.lang.Object;", 
            [["java.lang.Long", self.card_order_id],
              self.order_sender_user.facebook_token.token]].to_json
    workflow_id = "card-order-process-#{self.card_order_id.to_s}"

    tags = []
    tags << "sender-id-#{order_sender_user_id}"
    tags << "sender-last-#{order_sender_user.user_profile.last_name}"
    tags << "app-#{self.app.name}"
    tags << "order-number-#{self.order_number}"
    tags << "design-#{self.card_design.card_design_id}"

    workflow_type.start_execution input: input, workflow_id: workflow_id, tag_list: tags
  end

  def execute_share_workflow!
    swf = AWS::SimpleWorkflow.new
    domain = swf.domains["posto-#{Rails.env == "production" ? "prod" : "dev"}"]
    workflow_type = domain.workflow_types['CardShareWorkflow.shareOrder', CONFIG.for_app(self.app).order_workflow_version]
    input = ["[Ljava.lang.Object;", 
            [["java.lang.Long", self.card_order_id]]].to_json
    workflow_id = "card-order-share-#{self.card_order_id.to_s}"

    tags = []
    tags << "sender-id-#{order_sender_user_id}"
    tags << "sender-last-#{order_sender_user.user_profile.last_name}"
    tags << "app-#{self.app.name}"
    tags << "order-number-#{self.order_number}"
    tags << "design-#{self.card_design.card_design_id}"

    workflow_type.start_execution input: input, workflow_id: workflow_id, tag_list: tags
  end

  def relevant_address_requests
    Set.new.tap do |requests|
      self.card_printings.each do |card_printing|
        card_printing.recipient_user.received_address_requests.each do |request|
          requests << request
        end
      end
    end.to_a
  end

  def close_relevant_supplied_address_requests!
    relevant_address_requests.each(&:close_if_address_supplied!)
  end

  def number_of_credit_allocated_cards
    self.card_order_credit_allocation.try(:number_of_credited_cards) || 0
  end

  def allocated_credits
    self.card_order_credit_allocation.try(:allocated_credits) || 0
  end

  def allocate_and_deduct_credits!
    return if self.is_promo

    CONFIG.for_app(self.app) do |config|
      sender = self.order_sender_user

      number_of_credited_cards = sender.number_of_credited_cards_for_order_of_size(self.number_of_ordered_cards, app: self.app)

      if number_of_credited_cards > 0
        credit_allocation = self.card_order_credit_allocations.create(
          credits_per_card: config.card_credits,
          credits_per_order: config.processing_credits,
          number_of_credited_cards: number_of_credited_cards
        ).tap do |credit_allocation|
          sender.deduct_credits!(credit_allocation.allocated_credits,
                                app: app,
                                source_type: :card_order_debit,
                                source_id: self.card_order_id)
        end
      end
    end
  end

  def refund_allocated_credits_for_cards!(number_of_cards)
    card_order_credit_allocation = self.card_order_credit_allocation
    return 0 unless card_order_credit_allocation

    number_of_credit_allocated_cards = self.number_of_credit_allocated_cards
    number_of_cards_to_refund = [number_of_cards, number_of_credit_allocated_cards].min

    return 0 if number_of_cards_to_refund == 0
    
    # Include the processing fee if we are refunding the last card
    include_processing_fee = number_of_cards_to_refund == number_of_credit_allocated_cards

    number_of_credits_to_refund = number_of_cards_to_refund * card_order_credit_allocation.credits_per_card
    number_of_credits_to_refund += card_order_credit_allocation.credits_per_order if include_processing_fee

    remaining_number_of_credit_allocated_cards = number_of_credit_allocated_cards - number_of_cards_to_refund

    new_allocation = self.card_order_credit_allocations.create!(credits_per_card: card_order_credit_allocation.credits_per_card,
                                                                credits_per_order: card_order_credit_allocation.credits_per_order,
                                                                number_of_credited_cards: remaining_number_of_credit_allocated_cards)

    self.order_sender_user.add_credits!(number_of_credits_to_refund, 
                                        app: self.app,
                                        source_type: :card_order_credit,
                                        source_id: new_allocation.card_order_credit_allocation_id)

    number_of_credits_to_refund
  end

  def refund_all_allocated_credits!
    self.refund_allocated_credits_for_cards!(self.number_of_credit_allocated_cards)
  end

  def refund_allocated_credits_for_nonmailable_cards!
    number_of_nonmailable_cards = self.number_of_ordered_cards - self.number_of_mailable_cards

    if number_of_nonmailable_cards > 0
      self.refund_allocated_credits_for_cards!(number_of_nonmailable_cards)
    end
  end

  def update_author_promo_bit
    unless order_sender_user.sent_promo_card
      order_sender_user.sent_promo_card = true
      order_sender_user.save!
    end
  end

  def redeem_promo!
    return unless self.is_promo

    User.transaction_with_retry do
      unless self.order_sender_user.redeemed_promo_card
        self.order_sender_user.add_credits!(CONFIG.for_app(self.app).card_credits, 
                                            app: self.app,
                                            source_type: :promo,
                                            source_id: self.card_order_id)

        self.order_sender_user.redeemed_promo_card = true
        self.order_sender_user.save
      end
    end
  end
end
