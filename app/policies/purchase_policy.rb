class PurchasePolicy < ApplicationPolicy
  def index?
    user
  end
end
