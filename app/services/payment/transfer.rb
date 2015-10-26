module Payment
  class Transfer < Base
    def perform
      purchase && orders && finish_purchase
    end

    def redirect_path
      [Rails.application.routes.url_helpers.checkout_transfer_path(purchase.invoice_id), flash: { notice: 'Aguardando confirmação' }]
    end

    private

    def payment_method
      'transfer'
    end

    def taxes
      0.00
    end

    def send_mail
      PurchaseMailer.pending_transfer_payment(purchase).deliver_now
    end

    def save_purchase
      purchase.invoice_id = SecureRandom.hex(32)
      purchase.save
    end
  end
end
