TriboViva.Offers ?= {}

TriboViva.Offers.CreatePurchase = TriboViva.Offers.NewPurchase =
  checkRadioButtons: ->
    if document.getElementById("purchase_user_status_true").checked
      $('.unregistered-user-form').hide()
      $('.registered-user-form').show()
    else if document.getElementById("purchase_user_status_false").checked
      $('.registered-user-form').hide()
      $('.unregistered-user-form').show()

  init: ->
    total = $('#total-sum')
    original = total.data('original')
    format = total.data('format')
    unit = total.data('unit')
    formatedErrorValue = format.replace('%u', unit).replace('%n', '--')
    $('#purchase_amount').on 'keyup change', ->
      $this = $(this)
      val = $this.val()
      if val.match(/\d+/)
        val = parseInt(val)
        if val >= $this.prop('min') && val <= $this.prop('max')
          newValue = parseFloat(original) * val
          parsed = newValue.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, "$1,")
          parsed = parsed.replace(',', 'A')
          parsed = parsed.replace('.', total.data('separator'))
          parsed = parsed.replace('A', total.data('delimiter'))
          parsed = format.replace('%u', unit).replace('%n', parsed)
          total.text(parsed)
        else
          total.text(formatedErrorValue)
      else
        total.text(formatedErrorValue)

    TriboViva.Offers.NewPurchase.checkRadioButtons() # check on load

    $('#purchase_user_status_true, #purchase_user_status_false').change ->
      TriboViva.Offers.NewPurchase.checkRadioButtons() # check on change

  modules: -> []
