class PurchaseStatus < EnumerateIt::Base
  associate_values pending: 'pending',
                   confirmed: 'confirmed',
                   canceled: 'canceled'
end
