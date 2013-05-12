class GiftCreditsController
  show_lookup_error: (error) ->
    $("#lookup-controls").addClass("info");
    $("#lookup-code-error").text(error)
    
  clear_lookup_error: ->
    $("#lookup-controls").removeClass("info");
    $("#lookup-code-error").text("")

  init: ->
    self = this

    $("#lookup").click ->
      lookup_code = $("#lookup-code").val()

      return if lookup_code == ""

      unless lookup_code.match(/^[0-9]+$/)
        self.show_lookup_error("Your code should be all numbers.")
        return

      app_name = $("body").attr("data-app")

      self.clear_lookup_error()

      $.ajax "/apps/#{app_name}/gift_credits/#{lookup_code}.json", dataType: "json", success: (data) ->
        if data.card_printing_id?
          document.location.href = "/apps/#{app_name}/gift_credits/#{lookup_code}"
        else
          self.show_lookup_error("We couldn't find your card. Please double check your code.")

      false

    $("#purchase-button").click ->

      StripeCheckout.open
        key: $("body").attr("data-stripe-key"),
        amount: 1000,
        name: $("body").attr("data-app"),
        description: "A bag of chips",
        panelLabel: "Checkout",
        token: (res) ->
          input = $("<input type=hidden name=stripeToken />").val(res.id)
          $("purchase-form").append(input).submit()

      false

window.Posto.gift_credits = GiftCreditsController
