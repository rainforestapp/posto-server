class AdminAddressRequestController
  init: ->
    @isShifting = false
    @addressApiResponseId = null

    self = this

    $(document).bind 'keyup keydown', (e) ->
      self.isShifting = e.shiftKey
      true

    $(".message-word").click ->
      $(this).parent().toggleClass("active")
      self.syncCurrentWords()

    $(".message-word").mousemove ->
      if self.isShifting && !$(this).parent().hasClass("active")
        $(this).parent().toggleClass("active")
        self.syncCurrentWords()
    
    $(".submit-query").click ->
      self.performAddressApiCall()
      false

  syncCurrentWords: ->
    currentWords = []

    $(".message-word").each ->
      if $(this).parent().hasClass("active")
        currentWords.push($(this).data("word"))

    $(".pending-query").val(currentWords.join(" "))

  performAddressApiCall: ->
    query = $(".pending-query").val().replace(/\n/g, " ")

    $.ajax "/admin/address_api", data: { q: query }, success: (res) ->
      if res.data? and res.data.delivery_line_1?
        $(".query-result .delivery-line-1").text(res.data.delivery_line_1)
        $(".query-result .delivery-line-2").text(res.data.delivery_line_2)
        $(".query-result .last-line").text(res.data.last_line)
        $("#complete-form input").show()
        $("#complete-form-address-api-response-id").val(res.address_api_response_id)
      else
        $(".query-result .delivery-line-1").text("No match")
        $(".query-result .delivery-line-2").text("")
        $(".query-result .last-line").text("")
        $("#complete-form input").hide()
        $("#complete-form-address-api-response-id").val(null)

window.Posto.admin_address_requests = AdminAddressRequestController

