module CartList
  extend ActiveSupport::Concern

  CartListItem = Struct.new(:offer, :total_price, :piece_price, :quantity)

  def cart_list
    @cart_list ||= cart.map do |item|
      offer = offers.detect{ |_offer| _offer.id == item['id'] }
      piece = offer.value + offer.coordinator_tax + offer.operational_tax
      total = piece * item['quantity']
      CartListItem.new(offer, total, piece, item['quantity'])
    end
  end

  def total_value
    cart_list.map(&:total_price).sum
  end

  private

  def offers
    @offers ||= Offer.where(id: offer_ids).select(offer_attributes)
  end

  def offer_attributes
    %i(id value coordinator_tax operational_tax title image)
  end

  def offer_ids
    cart.map{ |item| item['id'] }
  end
end
