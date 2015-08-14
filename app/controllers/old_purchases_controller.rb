class OldPurchasesController < ApplicationController
  def show
    @purchase = Purchase.find_by(invoice_id: params[:id])
    @old_purchase = OldPurchase.find_by!(transaction_id: params[:id])
    @bank_account = @old_purchase.offer ? @old_purchase.offer.bank_account : BankAccount.first
  end

  def update
    purchase = OldPurchase.find_by(transaction_id: params[:id])
    if params[:old_purchase].present? && purchase.update_attributes(purchase_params)
      purchase.confirm!
      OldPurchaseMailer.confirmed_payment(params[:id]).deliver_now
      redirect_to success_old_purchase_path(purchase)
    else
      flash[:alert] = 'Você deve fazer o upload do recibo de pagamento!'
      redirect_to old_purchase_path(purchase)
    end
  end

  def success
    @purchase = OldPurchase.find_by(transaction_id: params[:id])

    if @purchase.status != OldPurchaseStatus::CONFIRMED
      flash[:alert] = 'Você deve fazer o upload do recibo de pagamento!'
      redirect_to old_purchase_path(@purchase)
    end
  end

  protected

  def purchase_params
    params.require(:old_purchase).permit(:receipt)
  end
end
