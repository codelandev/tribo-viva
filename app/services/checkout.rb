class Checkout
  def self.perform(cart_session, attributes = {})
    if %w(bank_slip credit_card transfer).include?(attributes[:method])
      payment = Payment.const_get(attributes.delete(:method).camelize).new(cart_session, attributes)
      payment.perform
      payment.redirect_path
    else
      [Rails.application.routes.url_helpers.checkout_path, flash: { alert: 'Tente novamente' }]
    end
  end
end
