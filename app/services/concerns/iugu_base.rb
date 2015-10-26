module IuguBase
  extend ActiveSupport::Concern

  included do
    attr_reader :charge
  end

  def perform
    if orders && charge! && success?
      finish_purchase
    else
      invoice.cancel
    end
    success?
  end

  def redirect_path
    if success?
      [Rails.application.routes.url_helpers.checkout_success_path(purchase.invoice_id), flash: { notice: "Compra realizada com sucesso!" }]
    else
      [Rails.application.routes.url_helpers.checkout_path, flash: { charge_messages: charge.try(:message) || 'Verifique os dados digitados' } ]
    end
  end

  private

  def items
    @items ||= purchase.orders.map do |order|
      {
        description: order.offer.title,
        quantity: order.quantity,
        price_cents: (order.offer_value*100).to_i
      }
    end << {
      description: 'Taxa da transação',
      quantity: 1,
      price_cents: (taxes*100).to_i
    }
  end

  def charge!
    @charge ||= Iugu::Charge.create(charge_param.merge({
      invoice_id: invoice.id,
      payer: payer
    }))
  end

  def payer
    {
      cpf_cnpj: user.cpf,
      name: user.name,
      email: user.email,
      phone_prefix: user.phone.first(2),
      phone: user.phone.last(8),
    }
  end

  def invoice
    @invoice ||= Iugu::Invoice.create(due_date.merge({
      email: user.email,
      items: items
    }))
  end

  def success?
    charge && charge.success
  end

  def save_purchase
    purchase.attributes = {
      taxes: taxes,
      invoice_id: invoice.id,
      invoice_url: invoice.secure_url,
      invoice_pdf: charge.pdf
    }
    purchase.save
  end

  def send_mail
    PurchaseMailer.pending_payment(purchase).deliver_now
  end
end
