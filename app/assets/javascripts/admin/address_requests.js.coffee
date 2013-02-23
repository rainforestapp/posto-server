class AdminAddressRequestController
  init: ->
    @isShifting = false
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
      console.log(res)

window.Posto.admin_address_requests = AdminAddressRequestController

