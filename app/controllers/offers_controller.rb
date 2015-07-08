class OffersController < ApplicationController
  def show
    @offer = Offer.find(params[:id])
  end

  def add_to_cart
    offer = Offer.find(params[:id])
    quantity = params[:quantity] ? params[:quantity] : 1

    offer_on_cart = session[:shopping_cart].select{|item| item['id'].to_i == offer.id}

    # Check if have any offer like this in cart
    if offer_on_cart.any?
      # Check the quantity already present on cart
      # if more or equal than 3, don't add
      if offer_on_cart.first['quantity'] >= 3
        respond_to do |format|
          format.json { render json: offer, status: :created, location: offer }
          format.html { redirect_to request.referer, alert: 'Excedeu o limite de 3 cotas para esta oferta'}
        end
      # if less than 3, add +1 to the offer quantity
      elsif offer_on_cart.first['quantity'] < 3
        session[:shopping_cart].map{|item| item['quantity'] += quantity if item['id'] == offer.id}
        respond_to do |format|
          format.json { render json: offer, status: :created, location: offer }
          format.html { redirect_to request.referer, notice: 'Cota adicionada ao carrinho!'}
        end
      end
    # if not, add the offer for the first time
    else
      session[:shopping_cart] << {id: offer.id, quantity: quantity}
      respond_to do |format|
        format.json { render json: offer, status: :created, location: offer }
        format.html { redirect_to request.referer, notice: 'Cota adicionada ao carrinho!'}
      end
    end
  end

  def remove_from_cart
    offer = Offer.find(params[:id])
    quantity = params[:quantity] ? params[:quantity] : 1

    offer_on_cart = session[:shopping_cart].select{|item| item['id'].to_i == offer.id}

    if offer_on_cart.any?
      if offer_on_cart.first['quantity'] <= quantity
        session[:shopping_cart].delete_if {|item| item['id'] == offer.id}
      else
        session[:shopping_cart].map{|item| item['quantity'] -= quantity if item['id'] == offer.id}
      end
      respond_to do |format|
        format.json { render json: offer, status: :created, location: offer }
        format.html { redirect_to request.referer, notice: 'Removido do carrinho!'}
      end
    else
      respond_to do |format|
        format.json { render json: offer, status: :created, location: offer }
        format.html { redirect_to request.referer, notice: 'Esta cota não está no seu carrinho'}
      end
    end
  end

  def clean_cart
    if session[:shopping_cart] = Array.new
      redirect_to request.referer, notice: 'Carrinho limpo com sucesso!'
    else
      redirect_to request.referer, alert: 'Erro ao limpar carrinho.'
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
        redirect_to old_purchase_path(@purchase.purchase), notice: 'Em breve você receberá o email de confirmação da sua compra!'
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
