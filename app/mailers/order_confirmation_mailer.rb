class OrderConfirmationMailer < ActionMailer::Base
  default from: "lulcards orders <orders@lulcards.com>"
  layout "email"

  def received_email(card_order)
    @card_order = card_order

    recipient_address = card_order.order_sender_user.try(:user_profile).try(:email)

    with_recipient_address_for_card_order(card_order) do |recipient_address|
      mail(to: recipient_address,
           subject: "Your lulcards order ##{card_order.order_number}")
    end
  end

  def with_recipient_address_for_card_order(card_order)
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
