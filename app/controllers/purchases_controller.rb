class PurchasesController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :update
  helper_method :collection

  def index
  end

  def update
    handler = Payment::NotificationHandler.new(params)
    handler.perform
    render nothing: true, status: handler.render_status
  end

  protected

  def collection
    current_user.purchases.includes(:orders)
  end
end
