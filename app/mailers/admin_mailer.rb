class AdminMailer < ActionMailer::Base
  default from: "lulcards admin <orders@lulcards.com>"
  layout "email"

  def email_errors(subject, body)
    @body = body

    mail(to: CONFIG.admin_error_email,
         subject: "[POSTO ERRORS] #{subject}")
  end
end
