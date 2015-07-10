class CheckoutContext
  attr_reader :user, :cart

  def initialize(user, cart)
    @user = user
    @cart = cart
  end
end
