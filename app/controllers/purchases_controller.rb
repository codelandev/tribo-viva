class PurchasesController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :update
  helper_method :collection

  def index
  end

  def update
    data     = params[:data]
    event    = params[:event]
    purchase = Purchase.find_by(invoice_id: data[:id])

    if purchase
      if event == 'invoice.refund' || event == 'invoice.status_changed'
        PurchaseMailer.confirmed_payment(purchase).deliver_now if data[:status] == 'paid'
        purchase.update_attributes(status: data[:status])
        render nothing: true, status: :ok, content_type: "text/html"
      elsif event == 'invoice.payment_failed'
        purchase.update_attributes(status: PurchaseStatus::CANCELED)
        render nothing: true, status: :ok, content_type: "text/html"
      else
        render nothing: true, status: :ok, content_type: "text/html"
      end
    else
      render nothing: true, status: :not_found, content_type: "text/html"
    end
  end

  protected

  def collection
    current_user.purchases
  end
end
