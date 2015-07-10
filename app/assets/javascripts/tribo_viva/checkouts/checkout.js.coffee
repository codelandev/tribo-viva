TriboViva.Checkouts ?= {}

TriboViva.Checkouts.Checkout =
  init: ->
    Iugu.setAccountID("79d7660c-6169-4e07-aed9-8a0883d5249a")
    Iugu.setTestMode(true) # disable on production

    # Set mask for card expiration date
    $(".js-credit-card-number").mask("9999 9999 9999 9999")
    $(".js-credit-card-card-expiration").mask("99/99")

    # To hide or show credit card form
    cc_checkbox       = $('#js-payment-method-credit-card')
    bs_checkbox       = $('#js-payment-method-bank-slip')
    cc_checkbox_label = $('#js-credit-card-checkbox-label')
    bs_checkbox_label = $('#js-bank-slip-checkbox-label')
    credit_card_form  = $('#js-creditcard-form')

    cc_checkbox_label.on 'click', ->
      cc_checkbox_label.addClass('active')
      cc_checkbox.prop('checked', true).attr('checked', true)

      bs_checkbox_label.removeClass('active')
      bs_checkbox.prop('checked', false).attr('checked', false)

      credit_card_form.show()

    bs_checkbox_label.on 'click', ->
      bs_checkbox_label.addClass('active')
      bs_checkbox.prop('checked', true).attr('checked', true)

      cc_checkbox_label.removeClass('active')
      cc_checkbox.prop('checked', false).attr('checked', false)

      credit_card_form.hide()

    # start form validation and submit
    $('#js-payment-form').submit (e) ->
      form           = $(this)
      cc             = $('.js-credit-card-number').val()
      cvv            = $('.js-credit-card-cvv').val()
      brand          = Iugu.utils.getBrandByCreditCardNumber(cc)
      cardName       = $('.js-credit-card-card-name').val()
      cardExpiration = $('.js-credit-card-card-expiration').val()

      if cc_checkbox.attr('checked')
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
