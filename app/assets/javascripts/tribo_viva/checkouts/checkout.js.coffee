TriboViva.Checkouts ?= {}

TriboViva.Checkouts.Checkout =
  init: ->
    widget = $('#iugu-widget')
    Iugu.setAccountID(widget.data('account'))
    if widget.data('environment') != 'production'
      Iugu.setTestMode(true)

    # Set mask for card expiration date
    $(".js-credit-card-number").mask("9999 9999 9999 9999")
    $(".js-credit-card-card-expiration").mask("99/99")

    # To hide or show credit card form
    creditCardForm          = $('#js-creditcard-form')
    creditCardTerms         = $('.js-terms')
    bankSlipCheckBox        = $('#js-payment-method-bank-slip')
    creditCardCheckBox      = $('#js-payment-method-credit-card')
    bankSlipCheckBoxLabel   = $('#js-bank-slip-checkbox-label')
    creditCardCheckBoxLabel = $('#js-credit-card-checkbox-label')

    creditCardCheckBoxLabel.on 'click', ->
      creditCardCheckBoxLabel.addClass('active')
      creditCardCheckBox.prop('checked', true).attr('checked', true)

      bankSlipCheckBoxLabel.removeClass('active')
      bankSlipCheckBox.prop('checked', false).attr('checked', false)

      creditCardForm.show()

    bankSlipCheckBoxLabel.on 'click', ->
      bankSlipCheckBoxLabel.addClass('active')
      bankSlipCheckBox.prop('checked', true).attr('checked', true)

      creditCardCheckBoxLabel.removeClass('active')
      creditCardCheckBox.prop('checked', false).attr('checked', false)

      creditCardForm.hide()

    creditCardTerms.on 'change', ->
      if $(this).is(':checked')
        $('.js-submit-payment').attr('disabled', false)
      else
        $('.js-submit-payment').attr('disabled', true)

    # start form validation and submit
    $('#js-payment-form').submit (e) ->
      form            = $(this)
      cc              = $('.js-credit-card-number').val()
      cvv             = $('.js-credit-card-cvv').val()
      brand           = Iugu.utils.getBrandByCreditCardNumber(cc)
      cardName        = $('.js-credit-card-card-name').val()
      cardExpiration  = $('.js-credit-card-card-expiration').val()

      if creditCardCheckBox.attr('checked')
        # first of all, handle errors on credit card form
        if !Iugu.utils.validateCreditCardNumber(cc, brand)
          $('.js-errors').text("Número do cartão incorreto")
          e.preventDefault()

        else if !Iugu.utils.validateCVV(cvv, brand)
          $('.js-errors').text("Código CVV incorreto")
          e.preventDefault()

        else if !Iugu.utils.validateExpirationString(cardExpiration)
          $('.js-errors').text("Validade incorreta")
          e.preventDefault()

        else if cardName == ''
          $('.js-errors').text("Preencha o nome do cartão")
          e.preventDefault()

        else if not creditCardTerms.is(':checked')
          $('.js-errors').text("Você deve aceitar os termos de compra")
          e.preventDefault()

        else
          # if none, clean the message
          $('.js-errors').text("")

          # start the procedure to get token
          tokenResponseHandler = (data) ->
            # unfortunatelly validation of name just occur when try to get token
            if data.errors && data.errors['last_name']
              $('.js-errors').text("Nome do cartão está incorreto")
              e.preventDefault()
            else
              $('#token').val(data.id)
              console.log $('#token').val()
              console.log form.get(0)
              form.get(0).submit()

        # call the token handler
        Iugu.createPaymentToken this, tokenResponseHandler

      else
        form.get(0).submit()

  modules: -> []
