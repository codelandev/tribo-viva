class OldPurchasesController < ApplicationController
  def show
    @purchase = OldPurchase.find_by!(transaction_id: params[:id])
  end

  def update
    purchase = OldPurchase.find_by(transaction_id: params[:id])
    if params[:purchase].present? && purchase.update_attributes(purchase_params)
      purchase.confirm!
      OldPurchaseMailer.confirmed_payment(purchase).deliver_now
      redirect_to success_old_purchase_path(purchase)
    else
      flash[:alert] = 'Você deve fazer o upload do recibo de pagamento!'
      redirect_to old_purchase_path(purchase)
    end
  end

  def success
    @purchase = OldPurchase.find_by(transaction_id: params[:id])

    if @purchase.status != PurchaseStatus::CONFIRMED
      flash[:alert] = 'Você deve fazer o upload do recibo de pagamento!'
      redirect_to old_purchase_path(@purchase)
    end
  end

  protected

  def purchase_params
    params.require(:purchase).permit(:receipt)
  end
end
