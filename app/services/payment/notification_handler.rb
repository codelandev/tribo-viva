module Payment
  class NotificationHandler
    attr_accessor :data, :event, :purchase

    def initialize(params)
      self.data = params[:data]
      self.event = params[:event]
      self.purchase = Purchase.find_by(invoice_id: data[:id])
      @success = false
    end

    def perform
      purchase && send_event(event.sub('.', '_')) && set_success
    end

    def render_status
      if success?
        :ok
      else
        :not_found
      end
    end

    def send_event(received_method)
      respond_to?(received_method) && send(received_method)
    end

    def success?
      purchase && @success
    end

    def set_success
      @success = true
    end

    def invoice_refund
      purchase.update_attributes(status: data[:status])
    end

    def invoice_status_changed
      if data[:status] == PurchaseStatus::PAID
        PurchaseMailer.confirmed_payment(purchase).deliver_now
      end
      purchase.update_attributes(status: data[:status])
    end

    def invoice_payment_failed
      purchase.update_attributes(status: PurchaseStatus::CANCELED)
    end
  end
end
