module Admin
  class MailerController < AdminControllerBase
    def preview_submitted
      @card_order = CardOrder.find(9)

      render file: 'order_confirmation_mailer/received_email.html.haml',
             layout: 'email'
    end

    def preview_printing
      @card_order = CardOrder.find(9)
      @card_printings = @card_order.card_printings

      render file: 'order_confirmation_mailer/printing_email.html.haml',
             layout: 'email'
    end
  end
end
