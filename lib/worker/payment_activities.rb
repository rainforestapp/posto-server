class PaymentActivities
  def charge_order_for_printing_ids(card_order_id, card_printing_ids)
    card_order = CardOrder.find(card_order_id)
    card_printing_ids = card_printing_ids.uniq

    mailable_card_printing_ids = card_order.mailable_card_printings.map(&:card_printing_id).sort

    if (card_printing_ids.sort - mailable_card_printing_ids).size > 0
      raise "printing id mismatch #{card_printing_ids.inspect} #{mailable_card_printing_ids.inspect}"
    end

    CONFIG.for_app(card_order.app) do |config|
      if card_order.mailable_card_printings.size > 0
        amount = 0

        CardOrder.transaction_with_retry do
          card_order.refund_allocated_credits_for_nonmailable_cards!
          amount = card_order.total_price_to_charge
        end
      
        if amount > 0
          stripe_customer = card_order.order_sender_user.stripe_customer
          return "no_customer" unless stripe_customer
          customer = Stripe::Customer.retrieve(stripe_customer.stripe_id)
          return "no_customer" unless customer
          return "no_card" unless customer["active_card"]

          begin
            charge = Stripe::Charge.create(
              amount: amount,
              currency: "usd",
              customer: customer["id"],
              description: "Charge #{card_printing_ids.inspect} Order ##{card_order_id}"
            )
          rescue Stripe::CardError => e
            begin
              stripe_customer.stripe_customer_card.mark_as_declined!
              stripe_customer.stripe_customer_card.append_to_metadata!(message: e.message)
            rescue Exception => e
            end
            return "declined"
          end

          if charge["failure_message"]
            if stripe_customer && stripe_customer.stripe_card
              begin
                stripe_customer.stripe_customer_card.mark_as_declined!
                stripe_customer.stripe_customer_card.append_to_metadata!(message: e.message)
              rescue Exception => e
              end
            end

            return "declined"
          end

          transaction = card_order.transactions.create!(
            charged_customer_type: :stripe,
            charged_customer_id: stripe_customer.stripe_customer_id,
            response: { stripe_charge_id: charge["id"] }
          )

          transaction.transaction_line_items.create!(
            description: "Processing Fee",
            price_units: config.processing_fee,
            currency: "usd",
            is_credit: false,
          )

          card_printing_ids.each do |card_printing_id|
            transaction.transaction_line_items.create!(
              description: "Card Printing ##{card_printing_id}",
              price_units: config.card_fee,
              currency: "usd",
              is_credit: false,
            )
          end
        end

        return "charged"
      else
        return "cancelled"
      end
    end
  end

  def check_if_charge_has_been_paid(card_order_id)
    card_order = CardOrder.find(card_order_id)
    amount = nil

    CardOrder.transaction_with_retry do
      amount = card_order.total_price_to_charge
    end

    return "free" if amount == 0

    transaction = card_order.transactions[0]
    return "no_transaction" unless transaction

    charge_id = transaction.response[:stripe_charge_id]
    return "no_charge_id" unless charge_id

    charge = Stripe::Charge.retrieve(charge_id)
    return "no_charge" unless charge

    if charge["failure_message"] 
      if stripe_customer && stripe_customer.stripe_card
        begin
          stripe_customer.stripe_card.mark_as_declined!
          stripe_customer.stripe_card.append_to_metadata!(message: charge["failure_message"])
        rescue nil
        end
      end

      return "declined" if charge["failure_message"]
    end

    return "paid" if charge["paid"]

    return "pending"
  end
end
