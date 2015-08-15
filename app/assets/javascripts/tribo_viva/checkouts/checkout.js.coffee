TriboViva.Checkouts ?= {}

TriboViva.Checkouts.Checkout =
  init: ->
    widget = $('#iugu-widget')
    Iugu.setAccountID(widget.data('account'))
    if widget.data('environment') != 'production'
      Iugu.setTestMode(true)
    Iugu.setup()

    # To hide or show credit card form
    divFees                 = $('#fees')
    creditCardForm          = $('#js-creditcard-form')
    creditCardTerms         = $('.js-terms')
    transferCheckBox        = $('#js-payment-method-transfer')
    bankSlipCheckBox        = $('#js-payment-method-bank-slip')
    creditCardCheckBox      = $('#js-payment-method-credit-card')
    bankSlipCheckBoxLabel   = $('#js-bank-slip-checkbox-label')
    transferCheckBoxLabel   = $('#js-transfer-checkbox-label')
    creditCardCheckBoxLabel = $('#js-credit-card-checkbox-label')

    creditCardForm.hide()

    fee        = 0
    sub_total  = parseFloat(divFees.data('total'))
    total      = accounting.formatMoney(sub_total+fee, "R$ ", 2, ".", ",")
    fee_string = accounting.formatMoney(fee, "R$ ", 2, ".", ",")
    $('.js-text-total-fee').text('Custo da Transação: ' + fee_string)
    $('.js-text-total').text('Total a Pagar: ' + total)

    creditCardCheckBoxLabel.on 'click', ->
      creditCardCheckBoxLabel.addClass('active')
      creditCardCheckBox.prop('checked', true).attr('checked', true)

      bankSlipCheckBoxLabel.removeClass('active')
      bankSlipCheckBox.prop('checked', false).attr('checked', false)
      transferCheckBoxLabel.removeClass('active')
      transferCheckBox.prop('checked', false).attr('checked', false)

      creditCardForm.show()

      fee       = parseFloat(divFees.data('card-fee'))
      sub_total = parseFloat(divFees.data('total'))
      total     = accounting.formatMoney(sub_total+fee, "R$ ", 2, ".", ",")
      fee_string = accounting.formatMoney(fee, "R$ ", 2, ".", ",")
      $('.js-text-total-fee').text('Custo da Transação: ' + fee_string)
      $('.js-text-total').text('Total a Pagar: ' + total)

    bankSlipCheckBoxLabel.on 'click', ->
      bankSlipCheckBoxLabel.addClass('active')
      bankSlipCheckBox.prop('checked', true).attr('checked', true)

      creditCardCheckBoxLabel.removeClass('active')
      creditCardCheckBox.prop('checked', false).attr('checked', false)
      transferCheckBoxLabel.removeClass('active')
      transferCheckBox.prop('checked', false).attr('checked', false)

      creditCardForm.hide()

      fee       = parseFloat(divFees.data('bank-slip-fee'))
      sub_total = parseFloat(divFees.data('total'))
      total     = accounting.formatMoney(sub_total+fee, "R$ ", 2, ".", ",")
      fee_string = accounting.formatMoney(fee, "R$ ", 2, ".", ",")
      $('.js-text-total-fee').text('Custo da Transação: ' + fee_string)
      $('.js-text-total').text('Total a Pagar: ' + total)

    transferCheckBoxLabel.on 'click', ->
      transferCheckBoxLabel.addClass('active')
      transferCheckBox.prop('checked', true).attr('checked', true)

      creditCardCheckBoxLabel.removeClass('active')
      creditCardCheckBox.prop('checked', false).attr('checked', false)
      bankSlipCheckBoxLabel.removeClass('active')
      bankSlipCheckBox.prop('checked', false).attr('checked', false)

      creditCardForm.hide()

      fee        = 0
      sub_total  = parseFloat(divFees.data('total'))
      total      = accounting.formatMoney(sub_total+fee, "R$ ", 2, ".", ",")
      fee_string = accounting.formatMoney(fee, "R$ ", 2, ".", ",")
      $('.js-text-total-fee').text('Custo da Transação: ' + fee_string)
      $('.js-text-total').text('Total a Pagar: ' + total)

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
              form.get(0).submit()

        # call the token handler
        Iugu.createPaymentToken this, tokenResponseHandler

      else
        form.get(0).submit()

  modules: -> []
