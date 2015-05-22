class PurchasesController < ApplicationController
  def show
    @purchase = Purchase.find_by(transaction_id: params[:id])
  end

  def update
    purchase = Purchase.find_by(transaction_id: params[:id])
    if params[:purchase].present? && purchase.update_attributes(purchase_params)
      flash[:notice] = 'Recibo enviado, aguarde até confirmarmos sua compra!'
    else
      flash[:alert] = 'Você deve fazer o upload do recibo de pagamento!'
    end

    redirect_to root_path
  end

  protected

  def purchase_params
    params.require(:purchase).permit(:receipt)
  end
end
