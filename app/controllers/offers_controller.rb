class OffersController < ApplicationController
  def show
    @offer = Offer.find(params[:id])
  end

  def add_to_cart
    offer = Offer.find(params[:id])

    if cart_session.add(offer, params[:quantity])
      @errors = nil
    else
      @errors = cart_session.errors.join('; ')
    end

    render layout: false
  end

  def remove_from_cart
    offer = Offer.find(params[:id])
    cart_session.remove(offer, params[:quantity])
    redirect_to cart_path, notice: 'Removido do carrinho!'
  end

  def clean_cart
    if cart_session.clean
      redirect_to cart_path, notice: 'Carrinho limpo com sucesso!'
    else
      redirect_to cart_path, alert: 'Erro ao limpar carrinho.'
    end
  end
end
