class CheckoutsController < ApplicationController
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :store_location, only: :checkout

  def checkout
    authorize :checkout
    if session[:shopping_cart].any?
      session[:shopping_cart].each do |item|
        can_pay = Offer.find(item['id']).can_pay_with_bank_slip?
        @block_bank_slip = !can_pay
      end
    end
  end

  def process_payment
    authorize :checkout

    # get payment method, if blank, it's credit card, if not, it's bank_slip
    param          = params[:token].empty? ? :method : :token
    payment_method = params[:method]
    taxes          = if payment_method == 'credit_card'
                       cart_session.total_card_fee
                     elsif payment_method == 'bank_slip'
                       cart_session.total_bank_slip_fee
                     elsif payment_method == 'transfer'
                       0
                     end

    # initialize the purchase object
    purchase = current_user.purchases.create(payment_method: payment_method)
    # Add all current items from cart to orders and purchase
    session[:shopping_cart].each do |item|
      offer = Offer.find(item['id'])
      Order.create(offer: offer,
                   purchase: purchase,
                   offer_value: offer.total,
                   quantity: item['quantity'])
    end

    if payment_method == 'transfer'
      purchase.invoice_id = SecureRandom.hex(32)
      OldPurchase.create(status: OldPurchaseStatus::PENDING, transaction_id: purchase.invoice_id, user: current_user)
      purchase.save
      OldPurchaseMailer.pending_payment(purchase.invoice_id).deliver_now
      session[:shopping_cart] = []
      flash[:notice] = 'Aguardando confirmação'
      path = old_purchase_path(purchase.invoice_id)
    else
      charge = Iugu::Charge.create({
        # here is where the method is determined, :token for CC or :method bank_slip
        param => params[param],
        email: current_user.email,
        tax_cents: (taxes*100).to_i,
        payer: {
          cpf_cnpj: current_user.cpf,
          name: current_user.name,
          email: current_user.email,
          phone_prefix: current_user.phone.first(2),
          phone: current_user.phone.last(8),
        },
        items: purchase.orders.map do |order|
          {
            description: order.offer.title,
            quantity: order.quantity,
            price_cents: (order.offer_value*100).to_i
          }
        end
      })

      if charge and charge.success
        purchase.update_attributes(taxes: taxes,
                                   invoice_id: charge.invoice_id,
                                   invoice_url: charge.url,
                                   invoice_pdf: charge.pdf)

        flash[:notice]          = "Compra realizada com sucesso!"
        flash[:charge_messages] = charge.message if payment_method == 'credit_card'
        session[:shopping_cart] = Array.new
        PurchaseMailer.pending_payment(purchase).deliver_now
        path = checkout_success_path(purchase.invoice_id)
      else
        purchase.destroy # remove the purchase if fail
        if payment_method == 'credit_card' && charge.errors.blank?
          flash[:charge_messages] = charge.message
        else
          flash[:alert] = "Foram imputados dados errados do cartão"
        end
        path = checkout_path
      end
    end

    redirect_to path
  end

  def success
    @purchase = Purchase.find_by(invoice_id: (params[:invoice_id] || params[:id])) || OldPurchase.find_by!(transaction_id: (params[:invoice_id] || params[:id]))
  end

  protected

  def pundit_user
    CheckoutContext.new(current_user, session[:shopping_cart])
  end

  def user_not_authorized
    if user_signed_in? && request.referer != cart_path
      flash[:alert] = "Para realizar pagamento você deve ter items no carrinho"
      redirect_to cart_path
    else
      flash[:alert] = "Faça login para acessar esta página"
      redirect_to new_user_session_path
    end
  end
end
