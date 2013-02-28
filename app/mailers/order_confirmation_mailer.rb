class OrderConfirmationMailer < ActionMailer::Base
  default from: "lulcards orders <orders@lulcards.com>"
  layout "email"

  def received_email(card_order)
    with_recipient_address_for_card_order(card_order) do |recipient_address|
      mail(to: recipient_address,
           subject: "Your lulcards order ##{card_order.order_number} has been received")
    end
  end

  def printing_email(card_order, card_printing_ids)
    @card_printings = CardPrinting.find(card_printing_ids)

    with_recipient_address_for_card_order(card_order) do |recipient_address|
      mail(to: recipient_address,
           subject: "Receipt for lulcards order ##{card_order.order_number}")
    end
  end

  def mailed_email(card_order, card_printing_ids)
    @card_printings = CardPrinting.find(card_printing_ids)

    with_recipient_address_for_card_order(card_order) do |recipient_address|
      mail(to: recipient_address,
           subject: "Your lulcards order ##{card_order.order_number} has been mailed")
    end
  end

  def declined_email(card_order)
    with_recipient_address_for_card_order(card_order) do |recipient_address|
      mail(to: recipient_address,
           subject: "Your lulcards payment method for order ##{card_order.order_number} was declined")
    end
  end

  def expired_email(card_order)
    with_recipient_address_for_card_order(card_order) do |recipient_address|
      mail(to: recipient_address,
           subject: "Your lulcards order ##{card_order.order_number} has been cancelled")
    end
  end

  def with_recipient_address_for_card_order(card_order)
    @card_order = card_order

    user_profile = card_order.order_sender_user.try(:user_profile) 
    recipient_email_address = user_profile.try(:email)
    recipient_name = user_profile.try(:name)
    recipient_email_address = "gfodor@gmail.com"

    if recipient_email_address && recipient_name
      yield "#{recipient_name} <#{recipient_email_address}>"
    elsif recipient_email_address
      yield recipient_email_address
    end
  end
end
