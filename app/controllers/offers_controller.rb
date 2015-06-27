class OffersController < ApplicationController
  def show
    @offer = Offer.find(params[:id])
  end

  def new_purchase
    @offer = Offer.find(params[:id])
    @purchase = PurchaseForm.new(@offer)
  end

  def create_purchase
    @offer = Offer.find(params[:id])

    if @offer.remaining >= permitted_params[:amount].to_i
      @purchase = PurchaseForm.new(@offer, permitted_params)
      if @purchase.save
        redirect_to purchase_path(@purchase.purchase), notice: 'Em breve você receberá o email de confirmação da sua compra!'
      else
        flash[:alert] = 'Preenchas corretamente suas informações'
        render :new_purchase
      end
    else
      redirect_to new_purchase_offer_path(@offer), alert: 'Não há esta quantidade disponível.'
    end
  end

  private

  def permitted_params
    attrs = %i(email name cpf phone address amount)
    params.require(:purchase_form).permit(*attrs)
  end
end
