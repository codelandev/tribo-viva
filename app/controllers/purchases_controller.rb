class PurchasesController < ApplicationController
  helper_method :collection

  def index
  end

  def update
    data     = params[:data]
    event    = params[:event]
    purchase = Purchase.where(invoice_id: data[:id])

    if purchase.exists?
      if event == 'invoice.refund' || event == 'invoice.status_changed'
        purchase.first.update_attributes(status: data[:status])
        render nothing: true, status: :ok, content_type: "text/html"
      elsif event == 'invoice.payment_failed'
        purchase.first.update_attributes(status: PurchaseStatus::CANCELED)
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
