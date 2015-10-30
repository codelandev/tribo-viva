class OfferItem < ActiveRecord::Base
  belongs_to :offer

  validates :name, :unit, :quantity, :unit_price, presence: true

  def total
    unit_price * quantity
  end
end
