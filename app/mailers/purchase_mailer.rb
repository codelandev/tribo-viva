class PurchaseMailer < ActionMailer::Base
  layout 'mailer'
  default from: 'confirmacao@triboviva.com.br'

  def pending_payment(purchase)
    @purchase = purchase
    mail to: @purchase.user.email, subject: 'Confirme sua compra e envie o seu comprovante'
  end

  def confirmed_payment(purchase)
    @purchase = purchase
    mail to: @purchase.user.email, subject: 'Confirmação de compra Tribo Viva'
  end
end
