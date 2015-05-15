TriboViva.Flash =
  init: ->
    setTimeout( ->
      $('.flash').slideDown()
    , 100)
    if $('.flash').length > 0
      setTimeout( ->
        $('.flash').slideUp()
      , 5000)
    $(document).click ->
      $('.flash').slideUp()
