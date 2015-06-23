# Preview all emails at http://localhost:3000/rails/mailers/purchase
require 'machinist'
class PurchaseMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/purchase/confirm
  def pending_payment
    PurchaseMailer.pending_payment(Purchase.last)
  end

  def confirmed_payment
    PurchaseMailer.confirmed_payment(Purchase.last)
  end
end
