class CheckoutsController < ApplicationController
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :store_location, only: [:transfer, :checkout]

  # Used to show the page to upload the transfer receipt
  def transfer
    @purchase = Purchase.find_by(invoice_id: params[:invoice_id])
    @bank_account = BankAccount.first
  end

  # Used to upload the transfer receipt
  def update
    purchase = Purchase.find_by(invoice_id: params[:invoice_id])
    if params[:purchase].present? && purchase.update_attributes(purchase_params)
      purchase.confirm!
      PurchaseMailer.confirmed_payment(purchase).deliver_now
      redirect_to checkout_success_path(purchase.invoice_id)
    else
      flash[:alert] = 'Você deve fazer o upload do recibo de pagamento!'
      redirect_to checkout_transfer_path(purchase.invoice_id)
    end
  end

  #
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
    payment_method = params[:method]
    taxes = if payment_method == 'credit_card'
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
      purchase.update_attributes(invoice_id: SecureRandom.hex(32))
      PurchaseMailer.pending_transfer_payment(purchase).deliver_now
      session[:shopping_cart] = []
      flash[:notice] = 'Aguardando confirmação'
      path = checkout_transfer_path(purchase.invoice_id)
    else
      # Check the payment method used (Iugu only accepts token & method)
      # If credit card, so use token param, if not, use
      param  = params[:method] == 'credit_card' ? :token : :method
      items = purchase.orders.map do |order|
                {
                  description: order.offer.title,
                  quantity: order.quantity,
                  price_cents: (order.offer_value*100).to_i
                }
              end
      items << {
                 description: 'Taxa da transação',
                 quantity: 1,
                 price_cents: (taxes*100).to_i
               }

      due_date = if payment_method == 'credit_card'
                   { due_date: Date.tomorrow.in_time_zone.strftime('%d/%m/%Y') }
                 else
                   { due_date: Date.today.in_time_zone.strftime('%d/%m/%Y') }
                 end
      invoice = Iugu::Invoice.create(due_date.merge({
        email: current_user.email,
        items: items
      }))
      charge = Iugu::Charge.create({
        param => params[param],
        invoice_id: invoice.id,
        payer: {
          cpf_cnpj: current_user.cpf,
          name: current_user.name,
          email: current_user.email,
          phone_prefix: current_user.phone.first(2),
          phone: current_user.phone.last(8),
        }
      })

      if charge and charge.success
        purchase.update_attributes(taxes: taxes,
                                   invoice_id: invoice.id,
                                   invoice_url: invoice.secure_url,
                                   invoice_pdf: charge.pdf)

        flash[:notice]          = "Compra realizada com sucesso!"
        session[:shopping_cart] = Array.new
        PurchaseMailer.pending_payment(purchase).deliver_now
        path = checkout_success_path(purchase.invoice_id)
      else
        purchase.destroy # remove the purchase if fail
        invoice.cancel
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
    @purchase = Purchase.find_by(invoice_id: (params[:invoice_id]))
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

  def purchase_params
    params.require(:purchase).permit(:receipt)
  end
end
