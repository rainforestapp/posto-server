class PaymentActivities
  def charge_order_for_printing_ids(card_order_id, card_printing_ids)
    card_order = CardOrder.find(card_order_id)
    card_printing_ids = card_printing_ids.uniq

    mailable_card_priting_ids = card_order.mailable_card_printings.map(&:card_printing_id).sort

    if (card_printing_ids.sort - mailable_card_priting_ids).size > 0
      raise "printing id mismatch #{card_printing_ids.inspect} #{mailable_card_priting_ids.inspect}"
    end

    if card_order.mailable_card_printings.size > 0
      stripe_customer = card_order.order_sender_user.stripe_customer
      return "no_customer" unless stripe_customer
      customer = Stripe::Customer.retrieve(stripe_customer.stripe_id)
      return "no_customer" unless customer
      return "no_card" unless customer["active_card"]

      amount = CardOrder.total_price_to_charge_for_number_of_cards(card_printing_ids.size)

      charge = Stripe::Charge.create(
        amount: amount,
        currency: "usd",
        customer: customer["id"],
        description: "Charge #{card_printing_ids.inspect} Order ##{card_order_id}"
      )

      if charge["failure_message"]
        return "declined"
      end

      transaction = card_order.transactions.create!(
        charged_customer_type: :stripe,
        charged_customer_id: stripe_customer.stripe_customer_id,
        response: { stripe_charge_id: charge["id"] }
      )

      transaction.transaction_line_items.create!(
        description: "Processing Fee",
        price_units: CONFIG.processing_fee,
        currency: "usd",
        is_credit: false,
      )

      card_printing_ids.each do |card_printing_id|
        transaction.transaction_line_items.create!(
          description: "Card Printing ##{card_printing_id}",
          price_units: CONFIG.card_fee,
          currency: "usd",
          is_credit: false,
        )
      end

      return "charged"
    else
      return "cancelled"
    end
  end

  def check_if_charge_has_been_paid(card_order_id)
    transaction = CardOrder.find(card_order_id).transactions[0]
    return "no_transaction" unless transaction

    charge_id = transaction.response[:stripe_charge_id]
    return "no_charge_id" unless charge_id

    charge = Stripe::Charge.retrieve(charge_id)
    return "no_charge" unless charge

    return "declined" if charge["failure_message"]
    return "paid" if charge["paid"]

    return "pending"
  end
end
