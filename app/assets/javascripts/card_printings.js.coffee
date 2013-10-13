class CardPrintingsController
  getPhoneDigits: (phoneNumber) ->
    return false if phoneNumber.match(/[^() 0-9+-]/)
    digits = phoneNumber.replace(/[^\d]/g, "")
    digits = digits.substring(1) if digits.charAt(0) == "1"
    return false unless digits.length == 10
    return digits

  init: ->
    self = this

    $("#phone-number").keyup ->
      phoneNumber = $("#phone-number").val()
      digits = self.getPhoneDigits(phoneNumber)

      $("#send-sms-button").toggleClass("disabled", digits == false)

    $("#sms-form").submit ->
      self.sendSMS()
      return false

  sendSMS: ->
    digits = this.getPhoneDigits($("#phone-number").val())
    app_name = $("body").attr("data-app")

    return unless digits

    $(".sent-by-sms").html("Sending message...")

    $.ajax "/apps/#{app_name}/sms_onboard_messages.json", data: { destination: digits }, method:"post", dataType: "json", success: (data) ->
      $(".sent-by-sms").html("Message sent!")

window.Posto.card_printings = CardPrintingsController
