class CheckoutPolicy < ApplicationPolicy
  def checkout?
    user
  end

  def process_payment?
    checkout?
  end

  def permitted_attributes
  end
end
