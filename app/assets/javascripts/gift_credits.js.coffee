class GiftCreditsController
  show_lookup_error: (error) ->
    $("#lookup-controls").addClass("info");
    $("#lookup-code-error").text(error)
    
  clear_lookup_error: ->
    $("#lookup-controls").removeClass("info");
    $("#lookup-code-error").text("")

  capitalize: (s) ->
    return s unless s && s.length > 1
    return s.substr(0,1).toUpperCase() + s.substr(1)

  sync_with_selected_package: ->
    self = this

    if self.selected_package_id
      $("#purchase-button").val("Buy #{self.selected_package_credits} credits for #{$("body").attr("data-sender-first-name")}").show()
      $("#purchase-form").show()
    else
      $("#purchase-form").hide()

    $(".package").each ->
      $(this).toggleClass("selected", $(this).attr("data-credit-package-id") == self.selected_package_id)


  init: ->
    self = this
    self.selected_package_id = null
    self.selected_package_name = null
    self.selected_package_credits = null
    self.selected_package_price = null
    self.selected_package_icon = null
    self.sync_with_selected_package()

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
        amount: parseInt(self.selected_package_price),
        name: self.capitalize($("body").attr("data-app")),
        description: "#{self.capitalize(self.selected_package_name)} - #{self.selected_package_credits} Credits",
        panelLabel: "Checkout",
        image: self.selected_package_icon,
        token: (res) ->
          input = $("<input type=hidden name=stripeToken />").val(res.id)
          $("purchase-form").append(input).submit()

      false

    $(".package").click ->
      self.selected_package_id = $(this).attr("data-credit-package-id")
      self.selected_package_price = $(this).attr("data-price")
      self.selected_package_credits = $(this).attr("data-credits")
      self.selected_package_name = $(this).attr("data-credit-package-name")
      self.selected_package_icon = $(this).attr("data-credit-package-icon")
      self.sync_with_selected_package()
      false

window.Posto.gift_credits = GiftCreditsController
