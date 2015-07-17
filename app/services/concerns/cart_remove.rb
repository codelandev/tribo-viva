module CartRemove
  extend ActiveSupport::Concern

  def remove(offer, quantity)
    quantity ||= 1
    if have_offer_in_cart?(offer)
      remove_item(offer, quantity)
    end
    session[:shopping_cart] = cart
  end

  private

  def remove_item(offer, quantity)
    if offer_in_cart(offer)['quantity'] <= quantity
      cart.delete_if{ |item| item['id'] == offer.id }
    else
      cart.map{ |item| item['quantity'] -= quantity if item['id'] == offer.id }
    end
  end
end
