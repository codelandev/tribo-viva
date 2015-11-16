class PurchasePolicy < ApplicationPolicy
  def index?
    user
  end

  def transfer?
    !record.has_invalid_offers? && user == record.user
  end
end
