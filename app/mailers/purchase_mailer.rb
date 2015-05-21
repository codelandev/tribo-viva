class PurchaseMailer < ActionMailer::Base
  layout 'mailer'
  default from: 'confirmacao@triboviva.com.br'

  def confirm(purchase)
    @purchase = purchase
    mail to: @purchase.user.email, subject: 'Confirmação de compra Tribo Viva'
  end
end
