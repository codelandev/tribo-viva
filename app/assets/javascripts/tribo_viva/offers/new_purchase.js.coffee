TriboViva.Offers ?= {}

TriboViva.Offers.NewPurchase =
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

  modules: -> []
