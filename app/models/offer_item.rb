class OfferItem < ActiveRecord::Base
  belongs_to :offer

  validates :name, :unit, :offer, :quantity, :unit_price, presence: true

  def total
    unit_price * quantity
  end
end
