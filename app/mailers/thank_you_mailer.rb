class ThankYouMailer < ActionMailer::Base
  layout "email_action"

  def thank_you(params)
    @task = params[:outgoing_email_task]
    @credit_order = nil
    @credit_order = CreditOrder.find(params[:credit_order_id]) if params[:credit_order_id]
    @note = params[:note]
    @person = Person.find(params[:person_id])
    @card_printing = CardPrinting.find(params[:card_printing_id])
    @card_design = @card_printing.card_order.card_design
    @app = @card_printing.card_order.app
    @config = CONFIG.for_app(@app)
    @recipient = @card_printing.card_order.order_sender_user
    @target_url = "http://#{@app.domain}/email_clicks/#{@task.try(:uid)}"
    @unsubscribe_url = "http://#{@app.domain}/unsubscribes/#{@task.try(:uid)}"

    @gender_color = "#5FB5E5"

    if @card_design.postcard_subject
      if @card_design.postcard_subject[:gender] == "girl"
        @gender_color = "#EB6C9A"
      end
    end

    recipient_email_address = @recipient.user_profile.try(:email)

    if Rails.env == "development"
      recipient_email_address = "gfodor@gmail.com"
    end

    subject = "#{@person.person_profile.name} thanked you for their #{@config.entity}!"

    if @credit_order
      subject = "#{@person.person_profile.name} purchased #{@credit_order.credits} #{@app.name} credits for you!"
    end

    @header_text = subject

    if recipient_email_address
      mail(to: recipient_email_address,
          from: @config.from_thank_you_email,
          subject: subject)
    else
      return nil
    end
  end
end
