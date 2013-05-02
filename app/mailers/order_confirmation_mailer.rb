class OrderConfirmationMailer < ActionMailer::Base
  default from: "lulcards orders <orders@lulcards.com>"
  layout "email"

  def received_email(card_order)
    with_recipient_address_for_card_order(card_order) do |recipient_address|
      mail(to: recipient_address,
           from: @from,
           subject: "Your #{@app.name} order has been received")
    end
  end

  def rejected_email(card_order)
    with_recipient_address_for_card_order(card_order) do |recipient_address|
      mail(to: recipient_address,
           from: @from,
           subject: "Your #{@app.name} order has been cancelled")
    end
  end

  def printing_email(card_order, card_printing_ids)
    @card_printings = CardPrinting.find(card_printing_ids)

    with_recipient_address_for_card_order(card_order) do |recipient_address|
      mail(to: recipient_address,
           from: @from,
           subject: "Receipt for your #{@app.name} order")
    end
  end

  def mailed_email(card_order, card_printing_ids)
    @card_printings = CardPrinting.find(card_printing_ids)

    with_recipient_address_for_card_order(card_order) do |recipient_address|
      mail(to: recipient_address,
           from: @from,
           subject: "Your #{@app.name} order has been mailed")
    end
  end

  def declined_email(card_order)
    with_recipient_address_for_card_order(card_order) do |recipient_address|
      mail(to: recipient_address,
           from: @from,
           subject: "Your #{@app.name} payment was declined")
    end
  end

  def expired_email(card_order)
    with_recipient_address_for_card_order(card_order) do |recipient_address|
      mail(to: recipient_address,
           from: @from,
           subject: "Your #{@app.name} order has been cancelled")
    end
  end

  def with_recipient_address_for_card_order(card_order)
    @card_order = card_order
    @app = card_order.app
    @config = CONFIG.for_app(@app)
    @from = @config.from_email
    
    if card_order
      @card_design = card_order.card_design
    end

    user_profile = card_order.order_sender_user.try(:user_profile) 
    recipient_email_address = user_profile.try(:email)
    recipient_name = user_profile.try(:name)

    if Rails.env == "development"
      recipient_email_address = "gfodor@gmail.com"
    end

    if recipient_email_address && recipient_name
      yield "#{recipient_name} <#{recipient_email_address}>"
    elsif recipient_email_address
      yield recipient_email_address
    end
  end
end
