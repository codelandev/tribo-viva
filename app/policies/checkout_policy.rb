class CheckoutPolicy < ApplicationPolicy
  def checkout?
    user && record.items_count > 0
  end

  def process_payment?
    checkout?
  end

  def permitted_attributes
  end
end
