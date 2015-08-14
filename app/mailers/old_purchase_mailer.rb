class OldPurchaseMailer < ActionMailer::Base
  layout 'mailer'
  default from: 'confirmacao@triboviva.com.br'

  def pending_payment(purchase_id)
    @purchase = Purchase.find_by(invoice_id: purchase_id)
    @purchase ||= OldPurchase.find_by(transaction_id: purchase_id)
    @bank_account = @purchase.is_a?(OldPurchase) ? @purchase.offer.bank_account : BankAccount.first
    mail to: @purchase.user.email, subject: 'Pague sua compra e envie o comprovante'
  end

  def confirmed_payment(purchase_id)
    @purchase = Purchase.find_by(invoice_id: purchase_id)
    @purchase ||= OldPurchase.find_by(transaction_id: purchase_id)
    mail to: @purchase.user.email, subject: 'Compra confirmada'
  end
end
