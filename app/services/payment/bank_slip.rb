module Payment
  class BankSlip < Base
    include IuguBase

    private

    def payment_method
      'bank_slip'
    end

    def taxes
      2.50
    end

    def due_date
      { due_date: Date.today.in_time_zone.strftime('%d/%m/%Y') }
    end

    def charge_param
      { method: 'bank_slip' }
    end
  end
end
