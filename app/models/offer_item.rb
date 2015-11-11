class OfferItem < ActiveRecord::Base
  belongs_to :offer

  validates :name, :unit, :quantity, :unit_price, presence: true

  validates :quantity, :unit_price, numericality: true

  def total
    unit_price * quantity
  end
end
