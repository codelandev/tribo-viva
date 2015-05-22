# Preview all emails at http://localhost:3000/rails/mailers/purchase
require 'machinist'
class PurchaseMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/purchase/confirm
  def confirm
    PurchaseMailer.confirm(Purchase.last)
  end
end
