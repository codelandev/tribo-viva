module Payment
  class Base
    attr_accessor :user, :cart, :success

    def initialize(cart, attributes = {})
      self.cart = cart
      self.user = attributes[:user]
      attributes && attributes.each do |attr, value|
        send("#{attr}=", value) if respond_to?("#{attr}=".to_sym)
      end
    end

    def perform
      fail NotImplementedError
    end

    def taxes
      fail NotImplementedError
    end

    def success?
      fail NotImplementedError
    end

    def save_purchase
      fail NotImplementedError
    end

    def send_mail
      fail NotImplementedError
    end

    def payment_method
      fail NotImplementedError
    end

    def redirect_path
      fail NotImplementedError
    end

    def purchase
      @purchase ||= user.purchases.new(payment_method: payment_method)
    end

    def orders
      @orders ||= cart.cart_list.map do |item|
        offer = item.offer
        purchase.orders.build(offer: offer, offer_value: offer.total, quantity: item.quantity)
      end
    end

    def finish_purchase
      save_purchase && send_mail && cart.clean
    end
  end
end
