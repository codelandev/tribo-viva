class PurchaseMailer < ActionMailer::Base
  layout 'mailer'
  default from: 'confirmacao@triboviva.com.br'

  def pending_payment(purchase)
    @purchase = purchase
    mail to: @purchase.user.email, subject: 'Compra pendente de pagamento'
  end

  def confirmed_payment(purchase)
    @purchase = purchase
    mail to: @purchase.user.email, subject: 'Compra confirmada'
  end
end
