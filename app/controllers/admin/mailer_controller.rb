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

    def preview_mailed
      @card_order = CardOrder.find(9)
      @card_printings = @card_order.card_printings

      render file: 'order_confirmation_mailer/mailed_email.html.haml',
             layout: 'email'
    end

    def preview_declined
      @card_order = CardOrder.find(9)

      render file: 'order_confirmation_mailer/declined_email.html.haml',
             layout: 'email'
    end

    def preview_expired
      @card_order = CardOrder.find(9)

      render file: 'order_confirmation_mailer/expired_email.html.haml',
             layout: 'email'
    end

    def preview_reminder
      @card_design = CardDesign.find(26)
      @target_url = "http://foobar"
      @last_names = ["Bubba Jones", "Sally Mae"]
      @age = "stupid"
      @subject_first_name = "Narf"
      @gender_color = "#EB6C9A"
      @gender_color = "#5FB5E5"

      render file: 'reminder_mailer/birthday_reminder.html.haml',
             layout: 'email_action'
    end
  end
end
