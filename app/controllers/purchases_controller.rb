class PurchasesController < ApplicationController
  def show
    @purchase = Purchase.find_by(transaction_id: params[:id])
  end

  def update
    purchase = Purchase.find_by(transaction_id: params[:id])
    if params[:purchase].present? && purchase.update_attributes(purchase_params)
      purchase.confirm!
      flash[:notice] = 'Recibo enviado, aguarde até confirmarmos sua compra!'
      redirect_to success_purchase_path(purchase)
    else
      flash[:alert] = 'Você deve fazer o upload do recibo de pagamento!'
      redirect_to purchase_path(purchase)
    end
  end

  def success
    @purchase = Purchase.find_by(transaction_id: params[:id])

    if @purchase.status != PurchaseStatus::CONFIRMED
      flash[:alert] = 'Você deve fazer o upload do recibo de pagamento!'
      redirect_to purchase_path(@purchase)
    end
  end

  protected

  def purchase_params
    params.require(:purchase).permit(:receipt)
  end
end
