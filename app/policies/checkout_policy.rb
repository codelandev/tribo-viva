class CheckoutPolicy < ApplicationPolicy
  def checkout?
    user.user && user.cart.any?
  end

  def process_payment?
    checkout?
  end

  def permitted_attributes
  end
end
