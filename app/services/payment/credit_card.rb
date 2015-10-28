module Payment
  class CreditCard < Base
    include IuguBase

    attr_accessor :token

    private

    def taxes
      cart.total_card_fee
    end

    def payment_method
      'credit_card'
    end

    def due_date
      { due_date: Date.tomorrow.in_time_zone.strftime('%d/%m/%Y') }
    end

    def charge_param
      { token: token }
    end
  end
end
