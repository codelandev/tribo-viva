class CartSession
  include CartAdd
  include CartClean
  include CartList
  include CartRemove

  attr_reader :session, :cart, :errors

  def initialize(session)
    session[:shopping_cart] ||= []
    @session = session
    @cart = session[:shopping_cart]
    @errors = []
  end

  def items_count
    cart.length
  end

  def policy_class
    CheckoutPolicy
  end

  private

  def have_offer_in_cart?(offer)
    !!offer_in_cart(offer)
  end

  def offer_in_cart(offer)
    @offer_in_cart ||= cart.detect do |item|
      id = offer.try(:id)
      id ||= offer
      item['id'].to_i == id
    end
  end
end
