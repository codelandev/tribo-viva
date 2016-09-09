class PurchaseMailer < ApplicationMailer
  def pending_transfer_payment(purchase)
    @purchase = purchase
    @bank_account = BankAccount.first
    mail to: @purchase.user.email, subject: 'Pague sua compra e envie o comprovante'
  end

  def pending_payment(purchase)
    @purchase = purchase
    mail to: @purchase.user.email, subject: 'Compra pendente de pagamento'
  end

  def confirmed_payment(purchase)
    @purchase = purchase
    mail to: @purchase.user.email, subject: 'Compra confirmada'
  end
end
