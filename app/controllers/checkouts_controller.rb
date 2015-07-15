class CheckoutsController < ApplicationController
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  protect_from_forgery except: :update
  before_action :store_location

  def checkout
    authorize :checkout
  end

  def process_payment
    authorize :checkout

    # get payment method, if blank, it's credit card, if not, it's bank_slip
    param          = params[:token].empty? ? :method : :token
    payment_method = params[:method] == '' ? 'credit_card' : 'bank_slip'

    # initialize the purchase object
    purchase = current_user.purchases.create
    # Add all current items from cart to orders and purchase
    session[:shopping_cart].each do |item|
      offer = Offer.find(item['id'])
      order = Order.create(offer: offer,
                           purchase: purchase,
                           offer_value: offer.value,
                           quantity: item['quantity'])
    end

    charge = Iugu::Charge.create({
      # here is where the method is determined, :token for CC or :method bank_slip
      param => params[param],
      email: current_user.email,
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
      purchase.update_attributes(invoice_id: charge.invoice_id,
                                 invoice_url: charge.url,
                                 invoice_pdf: charge.pdf,
                                 payment_method: payment_method)

      flash[:notice]          = "Compra realizada com sucesso!"
      flash[:charge_messages] = charge.message if payment_method == 'credit_card'
      session[:shopping_cart] = Array.new
      PurchaseMailer.pending_payment(purchase).deliver_now
      path = checkout_success_path(purchase.invoice_id)
    else
      purchase.destroy        # remove the purchase if fail
      if payment_method == 'credit_card' && charge.errors.blank?
        flash[:charge_messages] = charge.message
      else
        flash[:alert] = "Foram imputados dados errados do cartão"
      end
      path = checkout_path
    end

    redirect_to path
  end

  def success
    @purchase = Purchase.find_by(invoice_id: params[:invoice_id])
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

  def store_location
    store_location_for(:user, request.path)
  end
end
