module CartAdd
  extend ActiveSupport::Concern

  def add(offer, quantity)
    quantity = quantity.to_i
    quantity = 1 if quantity < 1
    @errors << 'Sem estoque' unless offer.have_stock?
    if have_offer_in_cart?(offer)
      add_existing_item(offer, quantity)
    else
      add_new_item(offer, quantity)
    end
    session[:shopping_cart] = cart
    @errors.empty?
  end

  private

  def add_existing_item(offer, quantity)
    existing = offer_in_cart(offer)['quantity']
    if check_quantity(offer, quantity, existing)
      cart.map do |item|
        if item['id'] == offer.id
          item['quantity'] = item['quantity'] + quantity
        end
      end
    end
  end

  def add_new_item(offer, quantity)
    if check_quantity(offer, quantity)
      @cart << { 'id' => offer.id, 'quantity' => quantity }
    end
  end

  def check_quantity(offer, more_quantity, existing_quantity = 0)
    total = more_quantity + existing_quantity
    @errors << 'Você pode comprar no máximo 3 cotas de cada oferta' if total > 3
    @errors << 'Quantidade indisponível' if total > offer.remaining
    total <= 3 && total <= offer.remaining
  end
end
