class OffersController < ApplicationController
  def show
    @offer = Offer.find(params[:id])
  end

  def new_purchase
    @offer = Offer.find(params[:id])
    @purchase = Purchase.new
  end

  def create_purchase
    @offer = Offer.find(params[:id])

    if @offer.remaining >= purchase_params[:amount].to_i
      if user_params[:user_status] == 'true'
        user     = User.find_by(email: user_params[:registered_user_email])
        purchase = Purchase.new(purchase_params.merge(user: user).merge(offer: @offer))

        if purchase.valid?
          purchase.save
          PurchaseMailer.pending_payment(purchase).deliver_now
          redirect_to purchase_path(purchase), notice: 'Em breve você receberá o email de confirmação da sua compra!'
        else
          flash[:alert] = 'Preenchas corretamente suas informações'
          @purchase = purchase
          render :new_purchase
        end

      elsif user_params[:user_status] == 'false'
        cpf      = user_params[:unregistered_user_cpf]
        name     = user_params[:unregistered_user_name]
        email    = user_params[:unregistered_user_email]
        phone    = user_params[:unregistered_user_phone]
        user     = User.new(email: email, cpf: cpf, name: name, phone: phone)
        purchase = Purchase.new(purchase_params.merge(user: user).merge(offer: @offer))

        if user.valid? && purchase.valid?
          user.save
          purchase.save
          PurchaseMailer.pending_payment(purchase).deliver_now
          redirect_to purchase_path(purchase), notice: 'Em breve você receberá o email de confirmação da sua compra!'
        else
          flash[:alert] = 'Preenchas corretamente suas informações'
          @purchase = purchase
          render :new_purchase
        end
      end

    else
      redirect_to new_purchase_offer_path(@offer), alert: 'Não há esta quantidade disponível.'
    end
  end

  protected

  def purchase_params
    params.require(:purchase).permit(:amount)
  end

  def user_params
    params.require(:purchase).permit(:user_status, :registered_user_email, :unregistered_user_name,
                                     :unregistered_user_email, :unregistered_user_cpf,
                                     :unregistered_user_phone)
  end
end
