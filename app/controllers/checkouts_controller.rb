class CheckoutsController < ApplicationController
  before_action :authenticate_user!, only: %i(checkout process_payment transfer)
  before_action :store_location, only: [:transfer, :checkout]

  # Used to show the page to upload the transfer receipt
  def transfer
    @purchase = Purchase.find_by(invoice_id: params[:invoice_id])
    authorize(@purchase)
    @bank_account = BankAccount.first
  end

  # Used to upload the transfer receipt
  def update
    purchase = Purchase.find_by(invoice_id: params[:invoice_id])
    if params[:purchase].present? && purchase.update_attributes(purchase_params)
      purchase.confirm!
      PurchaseMailer.confirmed_payment(purchase).deliver_now
      redirect_to checkout_success_path(purchase.invoice_id)
    else
      flash[:alert] = 'Você deve fazer o upload do recibo de pagamento!'
      redirect_to checkout_transfer_path(purchase.invoice_id)
    end
  end

  # GET /checkout
  def checkout
    authorize cart_session
    @block_bank_slip = false
    if cart_session.items_count > 0
      cart_session.cart_list.each do |item|
        next if @block_bank_slip
        can_pay = item.offer.can_pay_with_bank_slip?
        @block_bank_slip = !can_pay
      end
    end
  end

  def process_payment
    ab_finished(:communication_style)
    authorize cart_session

    redirect_to *Checkout.perform(cart_session, params.merge(user: current_user))
  end

  def success
    @purchase = Purchase.find_by(invoice_id: (params[:invoice_id]))
  end

  protected

  def user_not_authorized
    if @purchase && !policy(@purchase).transfer?
      redirect_to root_path, flash: { alert: I18n.t('checkouts.upload_denied') }
    else
      redirect_to cart_path, flash: { alert: I18n.t('checkouts.must_have_items_in_cart') }
    end
  end

  def purchase_params
    params.require(:purchase).permit(:receipt)
  end
end
