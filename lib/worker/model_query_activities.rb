require "set"

class ModelQueryActivities
  def get_outgoing_request_ids_for_card_order(card_order_id)
    get_request_ids_for_state_for_order(card_order_id, :outgoing)
  end

  def get_sent_request_ids_for_card_order(card_order_id)
    get_request_ids_for_state_for_order(card_order_id, :sent)
  end

  def get_printable_card_printing_ids(card_order_id)
    puts "print ids #{card_order_id}"
    [2123, 2456]
  end

  def mark_order_as_cancelled(card_order_id)
    puts "cancel #{card_order_id}"
  end

  def mark_order_as_complete(card_order_id)
    puts "complete #{card_order_id}"
  end

  private

  def get_request_ids_for_state_for_order(card_order_id, state)
    Set.new.tap do |request_ids|
      order = CardOrder.find(card_order_id)

      order.card_printings.each do |card_printing|
        recipient = card_printing.recipient_user

        recipient.received_address_requests.each do |request|
          if request.state == state
            request_ids << request.address_request_id
          end
        end
      end
    end
  end
end
