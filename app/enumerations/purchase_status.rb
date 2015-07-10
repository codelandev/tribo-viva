class PurchaseStatus < EnumerateIt::Base
  associate_values paid: 'paid',
                   draft: 'draft',
                   pending: 'pending',
                   expired: 'expired',
                   canceled: 'canceled',
                   refunded: 'refunded',
                   partially_paid: 'partially_paid'
end
