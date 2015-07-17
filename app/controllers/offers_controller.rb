class OffersController < ApplicationController
  def show
    @offer = Offer.find(params[:id])
  end

  def add_to_cart
    offer = Offer.find(params[:id])
    if cart_session.add(offer, params[:quantity])
      respond_to do |format|
        format.json { render json: offer, status: :created, location: offer }
        format.html { redirect_to cart_path, notice: 'Cota adicionada ao carrinho!'}
      end
    else
      respond_to do |format|
        format.json { render json: cart_session.errors.join('; '), status: :unprocessable_entity, location: offer }
        format.html { redirect_to cart_path, alert: cart_session.errors.join('; ')}
      end
    end
  end

  def remove_from_cart
    offer = Offer.find(params[:id])
    cart_session.remove(offer, params[:quantity])
    respond_to do |format|
      format.json { render json: offer, status: :created, location: offer }
      format.html { redirect_to cart_path, notice: 'Removido do carrinho!'}
    end
  end

  def clean_cart
    if cart_session.clean
      redirect_to cart_path, notice: 'Carrinho limpo com sucesso!'
    else
      redirect_to cart_path, alert: 'Erro ao limpar carrinho.'
    end
  end

  def new_purchase
    @offer = Offer.find(params[:id])
    @purchase = OldPurchaseForm.new(@offer)
  end

  def create_purchase
    @offer = Offer.find(params[:id])

    if @offer.remaining >= permitted_params[:amount].to_i
      @purchase = OldPurchaseForm.new(@offer, permitted_params)
      if @purchase.save
        flash[:notice] = 'Em breve você receberá o email de confirmação da sua compra!'
        redirect_to old_purchase_path(@purchase.purchase)
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
