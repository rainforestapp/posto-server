class AdminBirthdayRequestController
  init: ->
    @isShifting = false
    @birthday = null

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
      self.parseBirthday()
      false

  syncCurrentWords: ->
    currentWords = []

    $(".message-word").each ->
      if $(this).parent().hasClass("active")
        currentWords.push($(this).data("word"))

    $(".pending-query").val(currentWords.join(" "))

  parseBirthday: ->
    query = $(".pending-query").val().replace(/\n/g, " ")
    $("#complete-form-birthday").val(query)
    $("#complete-form input").show()

window.Posto.admin_birthday_requests = AdminBirthdayRequestController

