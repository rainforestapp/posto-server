class CardOrder < ActiveRecord::Base
  include AppendOnlyModel
  include HasAuditedState
  include HasOneAudited

  attr_accessible :app, :quoted_total_price, :card_design

  belongs_to :order_sender_user, class_name: "User"
  belongs_to :app
  belongs_to :card_design

  has_many :card_printings
  has_many :transactions, order: "created_at desc"

  has_audited_state_through :card_order_state

  def mark_as_cancelled!
    self.card_printings.each(&:mark_as_cancelled!)
    self.state = :cancelled
  end

  def mark_as_finished!
    self.state = :finished
  end

  def mailable_card_printings
    self.card_printings.select(&:mailable?)
  end

  def has_unmailable_printing?
    self.card_printings.reject(&:mailable?).size > 0
  end

  def self.total_price_to_charge_for_number_of_cards(number_of_cards)
    CONFIG.processing_fee + (CONFIG.card_fee * number_of_cards)
  end

  def total_price_to_charge
    number_of_cards = self.mailable_card_printings.size
    CardOrder.total_price_to_charge_for_number_of_cards(self.mailable_card_printings.size)
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
    workflow_type = domain.workflow_types['CardOrderWorkflow.processOrder', CONFIG.order_workflow_version]
    input = ["[Ljava.lang.Object;", 
            [["java.lang.Long", self.card_order_id],
              self.order_sender_user.facebook_token.token]].to_json

    workflow_type.start_execution input: input
  end
end
